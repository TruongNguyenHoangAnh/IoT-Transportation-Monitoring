import 'package:flutter/material.dart';
import '../home/widgets/alert_card.dart';

class TodayAlertScreen extends StatelessWidget {
  const TodayAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        centerTitle: true,
        title: const Text(
          "Today's Alert",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            AlertCard(alertTime: "02:00 AM"),
            SizedBox(height: 12),
            AlertCard(alertTime: "01:30 AM"),
            SizedBox(height: 12),
            AlertCard(alertTime: "12:50 AM"),
            SizedBox(height: 12),
            AlertCard(alertTime: "11:20 PM"),
            SizedBox(height: 12),
            AlertCard(alertTime: "10:45 PM"),
          ],
        ),
      ),
    );
  }
}
