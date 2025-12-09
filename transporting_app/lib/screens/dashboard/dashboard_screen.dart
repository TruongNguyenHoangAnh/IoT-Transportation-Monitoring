import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 📌 Title
              const Text(
                "Dashboard",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Real-time monitoring for ammunition transport",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 16),

              // 📌 SYSTEM OVERVIEW
              _sectionCard(
                title: "System Overview",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _overviewItem(Icons.local_shipping, "Total vehicles", "0")),
                        const SizedBox(width: 12),
                        Expanded(child: _overviewItem(Icons.play_circle, "Active transport", "0")),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _overviewItem(Icons.phonelink_off, "Offline devices", "0")),
                        const SizedBox(width: 12),
                        Expanded(child: _overviewItem(Icons.warning, "Critical alerts", "0")),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 📌 TRANSPORT STATUS
              _sectionCard(
                title: "Transport Status",
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,  
                      child: CustomPaint(
                        painter: _DonutChartPainter(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _StatusLegend(color: Colors.blue, label: "On Route", percent: "62%"),
                        _StatusLegend(color: Colors.green, label: "Completed", percent: "20%"),
                        _StatusLegend(color: Colors.orange, label: "Delayed", percent: "18%"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 📌 ALERT CHART
              _sectionCard(
                title: "Alert",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your alert per day",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: _LineChartPainter(),
                        child: Container(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // 📌 Section card
  // ============================
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  // 📌 Mini overview card
  Widget _overviewItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title\n$value",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================
// 📌 Status Legend Widget
// ============================
class _StatusLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String percent;

  const _StatusLegend({
    required this.color,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text("$label • $percent"),
      ],
    );
  }
}

// ============================
// 📌 Donut Chart
// ============================
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 22.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -90 * (3.14 / 180);

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.blue;

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.green;

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.orange;

    canvas.drawArc(rect, startAngle, 3.14 * 1.2, false, paint1);
    canvas.drawArc(rect, startAngle + 3.14 * 1.2, 3.14 * 0.4, false, paint2);
    canvas.drawArc(rect, startAngle + 3.14 * 1.6, 3.14 * 0.54, false, paint3);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ============================
// 📌 Line Chart
// ============================
class _LineChartPainter extends CustomPainter {
  final List<double> points = [10, 30, 18, 45, 25, 50, 35];

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintPoint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    const padding = 20.0;
    final step = (size.width - padding * 2) / (points.length - 1);

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
