import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';

// Screens
import 'screens/login.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/change_password_screen.dart';
import 'screens/profile/success_update_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'IoT Monitor',
      debugShowCheckedModeBanner: false,

      // =============================
      // LIGHT THEME
      // =============================
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),

      // =============================
      // DARK THEME
      // =============================
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
      ),

      themeMode: themeProvider.isDark
          ? ThemeMode.dark
          : ThemeMode.light,

      // =============================
      // ROUTES
      // =============================
      home: const LoginScreen(),

      routes: {
        "/login": (_) => const LoginScreen(),
        "/profile": (_) => const ProfileScreen(),
        "/edit_profile": (_) => const EditProfileScreen(),
        "/change_password": (_) => const ChangePasswordScreen(),
        "/success_update": (_) => const SuccessUpdateScreen(),
      },
    );
  }
}
