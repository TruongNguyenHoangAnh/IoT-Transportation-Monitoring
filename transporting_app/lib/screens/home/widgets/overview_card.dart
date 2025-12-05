import 'package:flutter/material.dart';
import 'overview_item.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text("Your transport status today",
              style: TextStyle(fontSize: 13, color: Colors.black54)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OverviewItem(title: "Transporting", count: 0),
              OverviewItem(title: "Device", count: 0),
              OverviewItem(title: "Alert", count: 0),
            ],
          )
        ],
      ),
    );
  }
}
