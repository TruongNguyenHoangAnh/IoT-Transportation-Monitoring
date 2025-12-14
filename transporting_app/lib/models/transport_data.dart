import 'package:cloud_firestore/cloud_firestore.dart';

class TransportData {
  final String deviceId;
  final Timestamp lastUpdated;
  final double temperature;
  final double battery;
  final double latitude;
  final double longitude;
  final int rssi;

  TransportData({
    required this.deviceId,
    required this.lastUpdated,
    required this.temperature,
    required this.battery,
    required this.latitude,
    required this.longitude,
    required this.rssi,
  });

  factory TransportData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final GeoPoint location =
        data['rental'] ?? const GeoPoint(0, 0);

    return TransportData(
      deviceId: data['device_id'] ?? doc.id,
      lastUpdated: data['last_updated'] ?? Timestamp.now(),
      temperature: (data['temp'] as num? ?? 0).toDouble(),
      battery: (data['battery'] as num? ?? 0).toDouble(),
      latitude: location.latitude,
      longitude: location.longitude,
      rssi: (data['rssi_lora'] as num? ?? 0).toInt(),
    );
  }

  /// Helper: kiểm tra trạng thái
  bool get isActive =>
      DateTime.now().difference(lastUpdated.toDate()).inMinutes <= 2;

  bool get isCritical =>
      temperature > 60 || battery < 3.3;
}
