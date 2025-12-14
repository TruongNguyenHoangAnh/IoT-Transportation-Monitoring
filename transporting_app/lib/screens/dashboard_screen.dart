import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transport_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Stream<QuerySnapshot> _devicesStream =
      FirebaseFirestore.instance.collection('devices').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: _devicesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final devices = snapshot.data!.docs
              .map((doc) => TransportData.fromFirestore(doc))
              .toList();

          final total = devices.length;
          final active = devices.where((d) => d.isActive).length;
          final offline = total - active;
          final critical = devices.where((d) => d.isCritical).length;

          final List<double> alertChart = [
            12,
            20,
            18,
            25,
            30,
            critical.toDouble()
          ];

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Real-time IoT Transportation Monitoring",
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 16),

                  _sectionCard(
                    title: "System Overview",
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: _overviewItem(
                                    Icons.local_shipping,
                                    "Total devices",
                                    "$total")),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _overviewItem(
                                    Icons.play_circle,
                                    "Active",
                                    "$active")),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                                child: _overviewItem(
                                    Icons.phonelink_off,
                                    "Offline",
                                    "$offline")),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _overviewItem(
                                    Icons.warning,
                                    "Critical",
                                    "$critical")),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _sectionCard(
                    title: "Transport Status",
                    child: SizedBox(
                      height: 160,
                      child: CustomPaint(
                        painter: DonutPainter(
                          activeCount: active,
                          offlineCount: offline,
                          criticalCount: critical,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _sectionCard(
                    title: "Alert Trends",
                    child: SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: LineChartPainter(alertChart),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 10),
          Text("$title\n$value"),
        ],
      ),
    );
  }
}

// =======================================================
// 🎯 CHARTS
// =======================================================

class DonutPainter extends CustomPainter {
  final int activeCount;
  final int offlineCount;
  final int criticalCount;

  DonutPainter({
    required this.activeCount,
    required this.offlineCount,
    required this.criticalCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total =
        (activeCount + offlineCount + criticalCount).toDouble();
    if (total == 0) total = 1;

    const stroke = 22.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -1.57;

    final paints = [
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.green,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.grey,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.redAccent,
    ];

    double currentAngle = startAngle;

    for (final entry in [
      activeCount,
      offlineCount,
      criticalCount
    ]) {
      final sweep = 3.14 * (entry / total);
      canvas.drawArc(rect, currentAngle, sweep, false,
          paints.removeAt(0));
      currentAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class LineChartPainter extends CustomPainter {
  final List<double> points;

  LineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintPoint = Paint()
      ..color = Colors.black;

    const padding = 20.0;
    final step =
        (size.width - padding * 2) / (points.length - 1);

    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = padding + step * i;
      final y = size.height - padding - points[i];

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, paintPoint);
    }

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(_) => true;
}
