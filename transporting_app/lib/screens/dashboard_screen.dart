import 'package:flutter/material.dart';
// --- BỎ IMPORT MQTT, THÊM 2 DÒNG NÀY ---
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transport_data.dart';
// ---

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        title: Text("Giám sát (Firestore)"),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.grey[200],
      // Dùng StreamBuilder để tự động cập nhật UI khi Firestore có data mới
      body: StreamBuilder<QuerySnapshot>(
        stream: _devicesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Xử lý lỗi
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }

          // Đang tải...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Không có dữ liệu
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Không có thiết bị nào đang hoạt động."));
          }

          // Có dữ liệu -> Hiển thị bằng ListView
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              // Parse dữ liệu bằng model mới (từ file transport_data.dart mới)
              TransportData data = TransportData.fromFirestore(document);

              // Chuyển Timestamp thành String ("... phút trước")
              String lastUpdate = TimeAgo.getTimeAgo(data.timestamp);

              // Hiển thị card thông tin
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.deviceId,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      Text(
                        "Cập nhật: $lastUpdate",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Divider(height: 20, thickness: 1),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCell(
                              "Nhiệt độ",
                              "${data.temperature.toStringAsFixed(1)} °C",
                              Icons.thermostat_outlined,
                              Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 16),
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
                      SizedBox(height: 16),
                      _buildInfoCell(
                        "Vị trí GPS",
                        "${data.latitude.toStringAsFixed(4)}, ${data.longitude.toStringAsFixed(4)}",
                        Icons.location_on,
                        Colors.blue,
                      ),
                      SizedBox(height: 16),
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
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
