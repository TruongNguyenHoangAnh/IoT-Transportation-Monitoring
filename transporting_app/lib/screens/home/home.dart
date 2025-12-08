import 'package:flutter/material.dart';

// Widgets của Home
import 'widgets/header.dart';
import 'widgets/overview_card.dart';
import 'widgets/section_header.dart';
import 'widgets/transport_card.dart';
import 'widgets/alert_card.dart';
import 'widgets/home_navbar.dart';

import '../transport/today_transport_screen.dart';
import '../alert/today_alert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      bottomNavigationBar: HomeNavBar(
        currentIndex: currentIndex,
        onChanged: (i) => setState(() => currentIndex = i),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const HeaderSection(),
              const SizedBox(height: 20),
              const OverviewCard(),
              const SizedBox(height: 20),

              // Section header + nút xem tất cả
              SectionHeader(
                title: "Today's Transport",
                count: 4,
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TodayTransportScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              // Transport card
              const TransportCard(),
              const SizedBox(height: 20),

              SectionHeader(
                title: "Today's Alert",
                count: 2,
                onViewAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TodayAlertScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              const AlertCard(alertTime: "02:00 AM"),
              const SizedBox(height: 12),
              const AlertCard(alertTime: "01:30 AM"),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}