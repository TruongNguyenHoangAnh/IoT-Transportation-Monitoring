import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String alertTime;
  const AlertCard({super.key, required this.alertTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("[Car Name] - [Alert ID]",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundColor: Colors.red),
              const SizedBox(width: 4),
              const Text("+3", style: TextStyle(color: Colors.red)),
              const Spacer(),
              Text(alertTime, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "View details",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
