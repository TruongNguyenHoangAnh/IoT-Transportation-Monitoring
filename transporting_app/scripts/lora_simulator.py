import time
import json
import random
import os
import paho.mqtt.client as mqtt
from datetime import datetime

# --- CẤU HÌNH ---
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
# Topic khớp với topic mà Cầu nối đang nghe (ammo_transport/+/telemetry)
MQTT_TOPIC = "ammo_transport/Ra-08H-Node1/telemetry" 

# Hàm tạo DỮ LIỆU ẢO (JSON P2P ĐƠN GIẢN)
def generate_p2p_data():
    temp = round(random.uniform(25.0, 35.0), 1)
    battery = round(random.uniform(3.5, 4.2), 2)
    lat = 10.7769 + random.uniform(-0.001, 0.001)
    lng = 106.7009 + random.uniform(-0.001, 0.001)
    rssi = random.randint(-80, -50)

    # Đây là cấu trúc JSON P2P đơn giản
    data = {
        "device_id": "Ra-08H-Node1", 
        "timestamp": int(time.time()),
        "temp": temp,
        "battery": battery,
        "gps": {
            "lat": lat,
            "lng": lng
        },
        "rssi_lora": rssi
    }
    return json.dumps(data)

# --- MQTT CLIENT ---
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"✅ (Giả lập) Đã kết nối tới MQTT Broker tại {MQTT_BROKER}")
    else:
        print(f"❌ (Giả lập) Kết nối thất bại, mã lỗi: {rc}")

def on_log(client, userdata, level, buf):
    # print paho internal logs to help debug connection/reason codes
    print(f"MQTT LOG (level={level}): {buf}")

# create client with explicit id to avoid collisions with other scripts
client = mqtt.Client(client_id=f"lora_sim_Ra-08H-Node1_{os.getpid()}_{random.randint(0,9999)}")
client.on_connect = on_connect
client.on_log = on_log

try:
    print("⏳ (Giả lập) Đang kết nối tới MQTT Broker...")
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_start() 

    while True:
        payload = generate_p2p_data()
        client.publish(MQTT_TOPIC, payload)
        print(f"📤 (Giả lập) [Gửi lúc {datetime.now().strftime('%H:%M:%S')}] Payload: {payload[:100]}...")
        
        time.sleep(10) # Gửi mỗi 10 giây 1 lần

except KeyboardInterrupt:
    print("\n🛑 (Giả lập) Đã dừng.")
    client.loop_stop()
    client.disconnect()
except Exception as e:
    print(f"\n❌ (Giả lập) Lỗi: {e}")