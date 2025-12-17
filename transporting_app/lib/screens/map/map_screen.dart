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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Maps",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),

      // ================= FIRESTORE STREAM =================
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('devices').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!.docs
              .map((doc) => TransportData.fromFirestore(doc))
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                // ================= MAP =================
                Container(
                  height: 260,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: defaultCenter,
                          initialZoom: 13,
                          maxZoom: 19,
                          minZoom: 3,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName:
                                'com.example.transporting_app',
                          ),

                          // ================= MARKERS =================
                          MarkerLayer(
                            markers: devices
                                .where((d) =>
                                    d.latitude != 0 && d.longitude != 0)
                                .map((device) {
                              return Marker(
                                point: LatLng(
                                  device.latitude,
                                  device.longitude,
                                ),
                                width: 40,
                                height: 40,
                                child: _buildMarker(device),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // ================= ZOOM BUTTONS =================
                      Positioned(
                        right: 10,
                        bottom: 70,
                        child: Column(
                          children: [
                            _controlBtn(
                              icon: Icons.add,
                              onTap: () {
                                final cam = _mapController.camera;
                                _mapController.move(
                                    cam.center, cam.zoom + 1);
                              },
                            ),
                            const SizedBox(height: 10),
                            _controlBtn(
                              icon: Icons.remove,
                              onTap: () {
                                final cam = _mapController.camera;
                                _mapController.move(
                                    cam.center, cam.zoom - 1);
                              },
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        right: 10,
                        bottom: 15,
                        child: _controlBtn(
                          icon: Icons.my_location,
                          onTap: () {
                            _mapController.move(defaultCenter, 14);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= LEGEND =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegend(Colors.green, "Normal"),
                    _buildLegend(Colors.orange, "Inactive"),
                    _buildLegend(Colors.red, "Critical"),
                  ],
                ),

                const SizedBox(height: 20),

                // ================= TRANSPORT LIST =================
                ...devices.map(_buildTransportCard),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= MARKER =================
  Widget _buildMarker(TransportData data) {
    Color color = Colors.green;

    if (data.isCritical) {
      color = Colors.red;
    } else if (!data.isActive) {
      color = Colors.orange;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          data.deviceId,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ================= CONTROL BUTTON =================
  Widget _controlBtn({required IconData icon, required VoidCallback onTap}) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        elevation: 3,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 45,
            height: 45,
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }

  // ================= LEGEND =================
  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  // ================= TRANSPORT CARD =================
  Widget _buildTransportCard(TransportData device) {
    final date = device.lastUpdated.toDate();
    final formattedTime = DateFormat('MMM d, HH:mm').format(date);

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping,
                  size: 28, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  device.deviceId,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                formattedTime, // ✅ Dec 17, 14:21
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Temp: ${device.temperature}°C | Battery: ${device.battery}V",
          ),

          const SizedBox(height: 6),

          Text(
            "Location: ${device.latitude.toStringAsFixed(4)}, "
            "${device.longitude.toStringAsFixed(4)}",
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransportDetailScreen(data: device),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "View details",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
