import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../models/transport_data.dart';
import '../transport/transport_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng defaultCenter = const LatLng(10.762622, 106.660172);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Maps"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('devices').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!.docs
              .map((e) => TransportData.fromFirestore(e))
              .where((d) => d.latitude != 0 && d.longitude != 0)
              .toList()
            ..sort(
              (a, b) =>
                  b.lastUpdated.compareTo(a.lastUpdated),
            );

          return Column(
            children: [
              // ================= MAP =================
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: defaultCenter,
                        initialZoom: 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          userAgentPackageName:
                              'com.example.transporting_app',
                        ),
                        MarkerLayer(
                          markers: devices.map((d) {
                            return Marker(
                              point: LatLng(d.latitude, d.longitude),
                              width: 42,
                              height: 42,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TransportDetailScreen(data: d),
                                    ),
                                  );
                                },
                                child: _buildMarker(d),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= LEGEND =================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _legend(Colors.green, "Normal"),
                    _legend(Colors.orange, "Inactive"),
                    _legend(Colors.red, "Critical"),
                  ],
                ),
              ),

              // ================= LIST =================
              Expanded(
                flex: 5,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: devices.length,
                  itemBuilder: (_, i) =>
                      _transportCard(context, devices[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarker(TransportData d) {
    Color color = d.isCritical
        ? Colors.red
        : d.isActive
            ? Colors.green
            : Colors.orange;

    return Container(
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
      child: const Icon(Icons.local_shipping,
          color: Colors.white, size: 20),
    );
  }

  Widget _legend(Color c, String t) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(t),
      ],
    );
  }

  Widget _transportCard(BuildContext context, TransportData d) {
    final time =
        DateFormat('MMM d, HH:mm').format(d.lastUpdated.toDate());

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.local_shipping, color: Colors.blue),
        title: Text(d.deviceId),
        subtitle: Text(
          "Temp: ${d.temperature}°C | Battery: ${d.battery}V\n$time",
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TransportDetailScreen(data: d),
            ),
          );
        },
      ),
    );
  }
}
