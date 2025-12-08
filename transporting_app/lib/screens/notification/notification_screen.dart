import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notification",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: [
          const SizedBox(height: 10),

          const Text(
            "Today",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          _notificationTile(
            icon: Icons.alarm,
            color: Colors.green.shade100,
            title: "Reminder for your meetings",
            subtitle: "Learn more about managing account info and activity",
            time: "9m ago",
          ),

          _notificationTile(
            icon: Icons.person,
            color: Colors.yellow.shade100,
            title: "Robert mention you!",
            subtitle: "Learn more about account info",
            time: "14m ago",
          ),

          _notificationTile(
            icon: Icons.alarm,
            color: Colors.red.shade100,
            title: "Reminder for your serial",
            subtitle: "Learn more about managing account info and activity",
            time: "9m ago",
          ),

          const SizedBox(height: 20),
          const Text(
            "Yesterday",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          _notificationTile(
            icon: Icons.alarm,
            color: Colors.green.shade100,
            title: "Reminder for your serial",
            subtitle: "Looking forward to it",
            time: "9h ago",
          ),

          _notificationTile(
            icon: Icons.alarm,
            color: Colors.yellow.shade100,
            title: "Reminder for your serial",
            subtitle: "Learn more about your account",
            time: "11h ago",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _notificationTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.grey.withOpacity(0.15),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: Colors.black),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
