import 'package:flutter/material.dart';

class TransportCard extends StatelessWidget {
  const TransportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ❌ KHÔNG có more icon ở đây nữa
          const Text(
            "[Car Name] - [Transport ID]",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.blue),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "On Route",
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Normal",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundColor: Colors.orange),
              const SizedBox(width: 6),
              const CircleAvatar(radius: 12, backgroundColor: Colors.purple),
              const SizedBox(width: 6),
              const CircleAvatar(radius: 12, backgroundColor: Colors.green),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "27 Apr",
                  style: TextStyle(color: Colors.black54),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.chat_bubble,
                        size: 18, color: Colors.black45),
                    SizedBox(width: 4),
                    Text("2", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
