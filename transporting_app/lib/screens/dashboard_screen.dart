import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transport_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 1. Biến lưu ngưỡng cảnh báo (Mặc định 30 độ C)
  double _tempThreshold = 21.0;

  // Tạo một Stream để lắng nghe collection 'devices' từ FIRESTORE
  final Stream<QuerySnapshot> _devicesStream = FirebaseFirestore.instance
      .collection('devices')
      .snapshots();

  @override
  void initState() {
    super.initState();
    // Không cần _setupMqtt() nữa!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giám sát vận chuyển"),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // 2. Widget Thanh điều chỉnh ngưỡng (Control Panel)
          _buildThresholdControl(),

          // 3. Danh sách thiết bị (StreamBuilder)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _devicesStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Xử lý lỗi
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
                  );
                }

                // Đang tải...
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Không có dữ liệu
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Không có thiết bị nào đang hoạt động."),
                  );
                }

                // Có dữ liệu -> Hiển thị bằng ListView
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: snapshot.data!.docs.map((
                    DocumentSnapshot document,
                  ) {
                    // Parse dữ liệu bằng model mới (từ file transport_data.dart mới)
                    TransportData data = TransportData.fromFirestore(document);

                    // Chuyển Timestamp thành String ("... phút trước")
                    String lastUpdate = TimeAgo.getTimeAgo(data.timestamp);

                    // 4. Logic kiểm tra cảnh báo
                    bool isDanger = data.temperature >= _tempThreshold;

                    // Hiển thị card thông tin
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      // Đổi màu nền nếu nguy hiểm
                      color: isDanger ? Colors.red.shade50 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // Viền đỏ nếu nguy hiểm
                        side: isDanger
                            ? const BorderSide(color: Colors.red, width: 2)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.deviceId,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDanger
                                        ? Colors.red[800]
                                        : Colors.indigo,
                                  ),
                                ),
                                // Badge trạng thái
                                if (isDanger)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "CẢNH BÁO",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              "Cập nhật: $lastUpdate",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Divider(height: 20, thickness: 1),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCell(
                                    "Nhiệt độ",
                                    "${data.temperature.toStringAsFixed(1)} °C",
                                    Icons.thermostat_outlined,
                                    // Đổi màu icon nhiệt độ nếu vượt ngưỡng
                                    isDanger ? Colors.red : Colors.redAccent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildInfoCell(
                                    "Pin",
                                    "${data.battery.toStringAsFixed(2)} V",
                                    Icons.battery_charging_full,
                                    Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoCell(
                              "Vị trí GPS",
                              "${data.latitude.toStringAsFixed(4)}, ${data.longitude.toStringAsFixed(4)}",
                              Icons.location_on,
                              Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            _buildInfoCell(
                              "Tín hiệu (RSSI)",
                              "${data.rssi} dBm",
                              Icons.signal_cellular_alt,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thanh trượt điều chỉnh ngưỡng
  Widget _buildThresholdControl() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ngưỡng cảnh báo nhiệt độ:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${_tempThreshold.toStringAsFixed(1)} °C",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Slider(
            value: _tempThreshold,
            min: 20.0,
            max: 80.0,
            divisions: 120, // Chia nhỏ để kéo mượt hơn
            activeColor: Colors.redAccent,
            label: _tempThreshold.toStringAsFixed(1),
            onChanged: (double value) {
              setState(() {
                _tempThreshold = value;
              });
            },
          ),
          const Text(
            "Kéo thanh trượt để thay đổi mức nhiệt độ kích hoạt cảnh báo đỏ.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper để vẽ các ô thông tin
  Widget _buildInfoCell(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

// Class helper nhỏ để hiển thị "xx phút trước"
class TimeAgo {
  static String getTimeAgo(Timestamp timestamp) {
    final Duration diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inSeconds < 60) {
      return "${diff.inSeconds} giây trước";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} phút trước";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} giờ trước";
    } else {
      return "${diff.inDays} ngày trước";
    }
  }
}
