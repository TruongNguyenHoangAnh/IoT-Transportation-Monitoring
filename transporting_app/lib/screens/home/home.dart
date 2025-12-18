import 'package:flutter/material.dart';

// Import các Widgets con của Home
import 'widgets/header.dart';
import 'widgets/overview_card.dart';
import 'widgets/section_header.dart';
import 'widgets/transport_card.dart';
import 'widgets/alert_card.dart';
import 'widgets/home_navbar.dart';

// Import màn hình Dashboard (Nơi có logic cảnh báo thật)
import '../dashboard_screen.dart';
import '../transport/today_transport_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến theo dõi tab hiện tại (0: Home, 1: Maps, 2: Dashboard, 3: Profile)
  int _currentIndex = 0;

  // Danh sách các màn hình tương ứng với 4 nút
  final List<Widget> _pages = [
    const HomeContent(), // Index 0: Trang chủ
    const PlaceholderScreen(title: "Bản đồ (Maps)"), // Index 1: Bản đồ
    const DashboardScreen(), // Index 2: Dashboard (Cảnh báo nằm ở đây!)
    const PlaceholderScreen(title: "Hồ sơ (Profile)"), // Index 3: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // BODY: Thay đổi nội dung dựa trên _currentIndex
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),

      // THANH ĐIỀU HƯỚNG
      bottomNavigationBar: HomeNavBar(
        currentIndex: _currentIndex,
        onChanged: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật tab để chuyển màn hình
          });
        },
      ),
    );
  }
}

// --- Nội dung Trang chủ (Home) ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const HeaderSection(),
          const SizedBox(height: 20),
          const OverviewCard(),
          const SizedBox(height: 20),
          SectionHeader(
            title: "Today's Transport",
            count: 4,
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodayTransportScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          const TransportCard(),
          const SizedBox(height: 20),
          SectionHeader(title: "Today's Alert", count: 2),
          const SizedBox(height: 10),
          const AlertCard(alertTime: "02:00 AM"),
          const SizedBox(height: 12),
          const AlertCard(alertTime: "01:30 AM"),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// --- Màn hình tạm cho các nút chưa làm ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("$title\nĐang phát triển", textAlign: TextAlign.center),
    );
  }
}
