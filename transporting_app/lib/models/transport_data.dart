import 'package:cloud_firestore/cloud_firestore.dart';

class TransportData {
  final String deviceId;
  final Timestamp timestamp; // <-- Kiểu dữ liệu đã đổi
  final double temperature;
  final double battery;
  final double latitude; // <-- Đã tách ra
  final double longitude; // <-- Đã tách ra
  final int rssi;

  TransportData({
    required this.deviceId,
    required this.timestamp,
    required this.temperature,
    required this.battery,
    required this.latitude,
    required this.longitude,
    required this.rssi,
  });

  // Factory constructor MỚI: Đọc từ Firestore
  factory TransportData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Lấy GeoPoint từ Firestore
    GeoPoint location = data['location'] ?? GeoPoint(0, 0);

    return TransportData(
      deviceId: data['device_id'] ?? 'unknown',
      timestamp: data['last_updated'] ?? Timestamp.now(),
      temperature: (data['temp'] as num? ?? 0.0).toDouble(),
      battery: (data['battery'] as num? ?? 0.0).toDouble(),
      latitude: location.latitude,
      longitude: location.longitude,
      rssi: (data['rssi_lora'] as num? ?? 0).toInt(),
    );
  }
}
