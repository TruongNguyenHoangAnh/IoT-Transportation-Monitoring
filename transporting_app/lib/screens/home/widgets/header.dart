import 'package:flutter/material.dart';
import '../../notification/notification_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage("assets/avatar.png"),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Your Position",
                style: TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationScreen(),
              ),
            );
          },
        )
      ],
    );
  }
}
