import paho.mqtt.client as mqtt
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import threading
import signal
import random
import json
import time
import os
import logging
import queue 
from logging.handlers import RotatingFileHandler

# Đọc từ biến môi trường
MQTT_BROKER = os.environ.get("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.environ.get("MQTT_PORT", 1883))
MQTT_TOPIC = os.environ.get("MQTT_TOPIC", "ammo_transport/+/telemetry")
CRED_PATH = os.environ.get("CRED_PATH", "scripts/serviceAccountKey.json")

# Cấu hình LOGGING 
LOG_DIR = os.path.join(os.path.dirname(__file__), 'logs')
os.makedirs(LOG_DIR, exist_ok=True)
logfile = os.path.join(LOG_DIR, 'mqtt_bridge_v2.log')

logger = logging.getLogger('mqtt_bridge_v2')
logger.setLevel(logging.DEBUG)

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
ch.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(message)s'))
fh = RotatingFileHandler(logfile, maxBytes=5*1024*1024, backupCount=5, encoding='utf-8')
fh.setLevel(logging.INFO)
fh.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(message)s'))
if not logger.hasHandlers():
    logger.addHandler(ch)
    logger.addHandler(fh)
logger.info("logger initialized")


# Khởi tạo Firebase
try:
    cred = credentials.Certificate(CRED_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    logger.info("Đã kết nối tới Firestore thành công!")
except Exception as e:
    logger.error(f"LỖI: Không thể kết nối Firestore. Hãy chắc chắn file '{CRED_PATH}' tồn tại.")
    logger.error(f"Lỗi chi tiết: {e}")
    exit()

db_queue = queue.Queue()
_stop_event = threading.Event()

# --- CÁC HÀM XỬ LÝ DATABASE (Worker Thread) ---
def firestore_worker():
    """Luồng này chạy nền, chỉ làm nhiệm vụ bốc data từ queue và ghi vào DB."""
    logger.info("Luồng ghi Firestore (Worker) đã khởi động.")
    while not _stop_event.is_set():
        try:
            # Lấy dữ liệu từ queue. Sẽ tự động block (ngủ) nếu queue rỗng
            data = db_queue.get(timeout=1.0) 
            
            # --- Toàn bộ logic xử lý DB được chuyển vào đây ---
            device_id = data.get('device_id') # Đã được kiểm tra ở on_message
            
            doc_data = dict(data)
            if 'gps' in doc_data and isinstance(doc_data['gps'], dict) \
                    and 'lat' in doc_data['gps'] and 'lng' in doc_data['gps']:
                try:
                    doc_data['location'] = firestore.GeoPoint(doc_data['gps']['lat'], doc_data['gps']['lng'])
                except Exception as e:
                    logger.warning(f"Không thể chuyển tọa độ sang GeoPoint: {e}")
                finally:
                    doc_data.pop('gps', None)
            
            doc_data['last_updated'] = firestore.SERVER_TIMESTAMP
            hist_data = dict(doc_data)
            hist_data['received_at'] = firestore.SERVER_TIMESTAMP

            doc_ref = db.collection('devices').document(device_id)
            hist_ref = doc_ref.collection('history').document()

            batch = db.batch()
            batch.set(doc_ref, doc_data, merge=True)
            batch.set(hist_ref, hist_data)

            ok = commit_with_retry(batch)
            if ok:
                logger.info(f"(Worker) Đã ghi DB cho: '{device_id}'. Queue hiện còn: {db_queue.qsize()}")
            else:
                logger.error(f"(Worker) Không lưu được cho '{device_id}' sau nhiều lần thử.")
            
            db_queue.task_done() # Báo cho queue là đã xử lý xong
            # --- Kết thúc logic xử lý DB ---

        except queue.Empty:
            # Queue rỗng, không có gì làm, lặp lại
            continue
        except Exception as e:
            logger.exception(f"(Worker) Lỗi nghiêm trọng: {e}")

def commit_with_retry(batch, max_attempts=5):
    delay = 1
    for attempt in range(1, max_attempts + 1):
        try:
            batch.commit()
            return True
        except Exception as e:
            logger.warning(f"Batch commit attempt {attempt} failed: {e}")
            if attempt == max_attempts:
                logger.error("Max batch commit attempts reached, giving up.")
                return False
            time.sleep(delay + random.random())
            delay = min(delay * 2, 30)

# --- CÁC HÀM XỬ LÝ MQTT (Main Thread) ---

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        logger.info(f"Đã kết nối tới MQTT Broker tại {MQTT_BROKER}")
        client.subscribe(MQTT_TOPIC)
        logger.info(f"    -> Đang lắng nghe topic: {MQTT_TOPIC}")
    else:
        logger.error(f"Kết nối MQTT thất bại, mã lỗi: {rc}")

def on_message(client, userdata, msg):
    """Hàm này giờ rất GỌN. Chỉ nhận, parse và quẳng vào queue."""
    try:
        payload_str = msg.payload.decode('utf-8')
        data = json.loads(payload_str)
        
        if 'raw' in data and ('rssi' in data or 'snr' in data):
            try:
                raw_string = data.get('raw')
                processed_data = json.loads(raw_string)
                
                processed_data['gateway_rssi'] = data.get('rssi')
                processed_data['gateway_snr'] = data.get('snr')
        
                if not processed_data.get('device_id'):
                    logger.warning("Nhận được tin nhắn nhưng thiếu 'device_id'. Bỏ qua.")
                    return

                # Chỉ cần quẳng vào queue, không cần chờ ghi DB
                db_queue.put(processed_data)
                logger.debug(f"Đã nhận tin từ '{processed_data.get('device_id')}', đưa vào queue.")

            except json.JSONDecodeError:
                logger.warning(f"Payload co truong 'raw' nhung khong phai JSON: {data.get('raw')}")
                return
        else:
            logger.warning(f"Payload khong co truong 'raw' hoac thieu 'rssi'/'snr': {payload_str}")
            return
    except json.JSONDecodeError:
        logger.warning(f"Lỗi: Không thể decode JSON (tầng ngoài): {msg.payload.decode('utf-8', errors='replace')}")
    except Exception as e:
        logger.exception(f"Lỗi khi xử lý on_message: {e}")

# (Hàm on_disconnect và _reconnect_loop giữ nguyên như code của bạn)
MAX_RECONNECT_DELAY = 60
def on_disconnect(client, userdata, rc):
    if rc == 0: 
        logger.info("MQTT: Disconnected cleanly ")
        return
    logger.warning(f"MQTT: Disconnected unexpectedly (rc={rc}). Attempting reconnect...")
    def _reconnect_loop():
        delay = 1
        while not _stop_event.is_set():
            try:
                if client.is_connected():
                    logger.debug("MQTT: already connected, exiting reconnect loop")
                    return
                logger.info("MQTT: Attempting to reconnect...")
                client.reconnect()
                logger.info("MQTT: Reconnected successfully")
                return
            except Exception as e:
                logger.warning(f"MQTT: Reconnect failed: {e}")
                time.sleep(delay + random.random())
                delay = min(delay * 2, MAX_RECONNECT_DELAY)
    t = threading.Thread(target=_reconnect_loop, daemon=True)
    t.start()

def on_log(client, userdata, level, buf):
    logger.debug(f"MQTT LOG (level={level}): {buf}")

def _graceful_shutdown(signum=None, frame=None):
    logger.info("Shutdown requested, stopping...")
    _stop_event.set()
    try:
        client.disconnect()
    except Exception:
        pass
    client.loop_stop()
    logger.info("Stopped.")

worker = threading.Thread(target=firestore_worker, daemon=True)
worker.start()

client = mqtt.Client(client_id=f"mqtt_to_firestore_bridge_{os.getpid()}_{random.randint(0,9999)}")
client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect
client.on_log = on_log

try:
    client.connect(MQTT_BROKER, MQTT_PORT, keepalive=60)
except Exception as e:
    logger.error(f"Initial connect failed: {e} — continuing, reconnect thread will try.")

client.loop_start()

signal.signal(signal.SIGINT, _graceful_shutdown)
signal.signal(signal.SIGTERM, _graceful_shutdown)
logger.info("Script cầu nối đang chạy... Nhấn Ctrl+C để dừng.")
try:
    while not _stop_event.is_set():
        time.sleep(1)
except KeyboardInterrupt:
    _graceful_shutdown()