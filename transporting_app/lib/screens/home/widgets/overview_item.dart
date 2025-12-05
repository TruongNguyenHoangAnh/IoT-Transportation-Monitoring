import 'package:flutter/material.dart';

class OverviewItem extends StatelessWidget {
  final String title;
  final int count;

  const OverviewItem({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$count",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
