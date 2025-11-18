import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart'; // Import màn hình dashboard
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Monitor',
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG ở góc phải trên
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(), // Đặt DashboardScreen làm màn hình chính
    );
  }
}
