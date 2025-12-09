import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --------------------------- SEARCH BAR ----------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 22, color: Colors.black54),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search by car name or transport ID",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune, size: 22, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Live Transport Map",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Track your vehicles in real-time",
                style: TextStyle(color: Colors.black54),
              ),
            ),

            const SizedBox(height: 14),

            // --------------------------- MAP WITH CONTROLS ---------------------------
            Container(
              height: 250,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // ------------------- OSM MAP -------------------
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
                        userAgentPackageName: 'com.example.transporting_app',
                      ),

                      // ------------------- MARKERS -------------------
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: const LatLng(10.8782516, 106.8037156),
                            width: 40,
                            height: 40,
                            child: _buildMarker(Colors.green, "A12"),
                          ),
                          Marker(
                            point: const LatLng(10.76, 106.67),
                            width: 40,
                            height: 40,
                            child: _buildMarker(Colors.orange, "C0"),
                          ),
                          Marker(
                            point: const LatLng(10.758, 106.655),
                            width: 40,
                            height: 40,
                            child: _buildMarker(Colors.red, "B1"),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ------------------- ZOOM BUTTONS -------------------
                  Positioned(
                    right: 10,
                    bottom: 70,
                    child: Column(
                      children: [
                        _controlBtn(
                          icon: Icons.add,
                          onTap: () {
                            final cam = _mapController.camera;
                            _mapController.move(cam.center, cam.zoom + 1);
                          },
                        ),
                        const SizedBox(height: 10),
                        _controlBtn(
                          icon: Icons.remove,
                          onTap: () {
                            final cam = _mapController.camera;
                            _mapController.move(cam.center, cam.zoom - 1);
                          },
                        ),
                      ],
                    ),
                  ),

                  // ------------------- RECENTER BUTTON -------------------
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

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegend(Colors.green, "Normal"),
                _buildLegend(Colors.orange, "Warning"),
                _buildLegend(Colors.red, "Critical"),
              ],
            ),

            const SizedBox(height: 20),

            _buildTransportCard(),
            const SizedBox(height: 12),
            _buildTransportCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --------------------------- MARKER WIDGET ---------------------------
  Widget _buildMarker(Color color, String id) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          id,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // --------------------------- CONTROL BUTTON ---------------------------
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

  // --------------------------- LEGEND ---------------------------
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

  // --------------------------- TRANSPORT CARD ---------------------------
  Widget _buildTransportCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18),
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
          Row(
            children: [
              const Icon(Icons.local_shipping, size: 28, color: Colors.blue),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Car Name: A12\nTransport ID: T-634F",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              const Text("02:00 AM", style: TextStyle(color: Colors.black54)),
            ],
          ),

          const SizedBox(height: 12),

          const Text("Current Location: 10°25'43.59\" N 106°48'24.37\" E",
              style: TextStyle(color: Colors.black87)),
          const SizedBox(height: 4),

          const Text("Cargo: Bulk", style: TextStyle(color: Colors.black87)),
          const SizedBox(height: 4),

          Row(
            children: [
              const Text("Status: ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Normal",
                    style: TextStyle(color: Colors.green, fontSize: 13)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransportDetailScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.grey.shade200,
              ),
              child: const Text("View details",
                  style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}
