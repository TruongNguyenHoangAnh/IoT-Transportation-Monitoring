import 'package:flutter/material.dart';
import '../../models/transport_data.dart';

class TransportDetailScreen extends StatelessWidget {
  final TransportData data;

  const TransportDetailScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Transport Detail",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    color: Colors.black.withValues(alpha: 0.08),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      const Icon(Icons.local_shipping,
                          color: Colors.blue, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Device ID: ${data.deviceId}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "${data.lastUpdated.toDate().hour.toString().padLeft(2, '0')}:"
                        "${data.lastUpdated.toDate().minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),

                  _divider(),

                  const Text("General Information",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),

                  _infoRow(
                    Icons.location_on,
                    "Location",
                    "${data.latitude}, ${data.longitude}",
                  ),

                  _infoRow(
                    Icons.info,
                    "Status",
                    data.isActive ? "Active" : "Offline",
                  ),

                  _divider(),

                  const Text("Sensor Data",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),

                  _infoRow(
                      Icons.thermostat,
                      "Temperature",
                      "${data.temperature} °C"),

                  _infoRow(Icons.battery_full, "Battery",
                      "${data.battery} %"),

                  _infoRow(
                      Icons.network_cell,
                      "RSSI",
                      "${data.rssi} dBm"),

                  _divider(),

                  const Text("Alerts",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),

                  const SizedBox(height: 8),

                  if (data.isCritical)
                    _alertItem("⚠ Critical condition detected")
                  else
                    _alertItem("No alerts"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        height: 1,
        color: Colors.grey.shade300,
      );

  Widget _alertItem(String text) {
    return Row(
      children: [
        const Icon(Icons.warning, color: Colors.red, size: 20),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }
}
