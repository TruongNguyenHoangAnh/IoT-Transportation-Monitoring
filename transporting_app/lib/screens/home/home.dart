import 'package:flutter/material.dart';

// ==================== Home widgets ====================
import 'widgets/header.dart';
import 'widgets/overview_card.dart';
import 'widgets/section_header.dart';
import 'widgets/transport_card.dart';
import 'widgets/alert_card.dart';
import 'widgets/home_navbar.dart';

// ==================== Screens ====================
import '../transport/today_transport_screen.dart';
import '../alert/today_alert_screen.dart';
import '../map/map_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // ⭐ Pages của Bottom Navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      _HomeContent(),
      MapScreen(),
      DashboardScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // ====================
      // Body
      // ====================
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // ====================
      // Bottom Navigation
      // ====================
      bottomNavigationBar: HomeNavBar(
        currentIndex: _currentIndex,
        onChanged: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

// ============================================================================
// ⭐ HOME CONTENT
// ============================================================================
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // TODO: refresh Firestore / Provider nếu cần
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ====================
              // Header
              // ====================
              const HeaderSection(),
              const SizedBox(height: 20),

              // ====================
              // Overview
              // ====================
              const OverviewCard(),
              const SizedBox(height: 24),

              // ====================
              // Today's Transport
              // ====================
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
              const TransportCard(),
              const SizedBox(height: 24),

              // ====================
              // Today's Alert
              // ====================
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

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
