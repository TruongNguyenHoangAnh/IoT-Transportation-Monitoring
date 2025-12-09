import 'package:flutter/material.dart';

class TransportDetailScreen extends StatelessWidget {
  const TransportDetailScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            // ------------------ MAIN CARD ------------------
            Container(
              width: double.infinity,
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
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_shipping,
                            color: Colors.blue, size: 26),
                      ),
                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          "Car Name: A12\nTransport ID: T-634F",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),

                      const Text("02:00 AM",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ------------------ GENERAL INFO ------------------
                  const Text(
                    "General information",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 8),

                  _infoRow(Icons.location_on, "Current Location",
                      "10°25'43.59\"N 106°48'24.37\"E"),

                  _infoRow(Icons.inventory_2, "Cargo", "Bulk"),
                  _infoRow(Icons.info, "Status", "Normal"),
                  _infoRow(Icons.person, "Driver", "Nguyen Van A"),

                  _divider(),

                  // ------------------ SENSOR DATA ------------------
                  const Text(
                    "Sensor data",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 8),

                  _infoRow(Icons.thermostat, "Temperature", "23.4°C"),
                  _infoRow(Icons.water_drop, "Humidity", "55%"),
                  _infoRow(Icons.vibration, "Vibration", "1.25"),

                  _divider(),

                  // ------------------ CONNECTIVITY ------------------
                  const Text(
                    "Device Connectivity",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 8),

                  _infoRow(Icons.network_cell, "Signal Strength (RSSI)", "-45.0"),
                  _infoRow(Icons.network_check, "Signal Noise Ratio (SNR)", "5.2"),

                  _divider(),

                  // ------------------ ALERTS ------------------
                  const Text(
                    "Sensor Data",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 10),

                  _alertItem("Alert 1"),
                  const SizedBox(height: 6),
                  _alertItem("Alert 2"),

                  const SizedBox(height: 20),

                  // ------------------ VIEW ROUTE BUTTON ------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "View Route",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------- HELPER WIDGETS -----------

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          )
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
