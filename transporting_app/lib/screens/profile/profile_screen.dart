import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '/providers/theme_provider.dart';
import 'edit_profile_screen.dart'; 
import 'change_password_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationOn = true;
  String selectedLanguage = "English";

  File? avatarFile;

  Future<void> pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;
    if (file != null) {
      setState(() => avatarFile = File(file.path));
    }
  }

  void showLanguagePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption("English"),
            _languageOption("Vietnamese"),
            _languageOption("Japanese"),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String lang) {
    return Row(
      children: [
        Radio<String>(
          value: lang,
          groupValue: selectedLanguage,
          onChanged: (value) {
            setState(() => selectedLanguage = value!);
            Navigator.pop(context);
          },
        ),
        Text(lang),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.isDark;

    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // ===========================
              // Avatar + Edit Profile button
              // ===========================
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickAvatar,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundColor: Colors.grey.shade400,
                        backgroundImage:
                            avatarFile != null ? FileImage(avatarFile!) : null,
                        child: avatarFile == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: isDark ? Colors.white : Colors.black54,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ⭐ Nút Edit Profile
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // ===========================
              // General
              // ===========================
              Text("General",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )),
              const SizedBox(height: 10),

              _menuToggle(
                icon: Icons.notifications_none,
                title: "Notifications",
                value: notificationOn,
                onChanged: (v) => setState(() => notificationOn = v),
                isDark: isDark,
              ),

              _menuAction(
                icon: Icons.language,
                title: "Language",
                trailing: selectedLanguage,
                onTap: showLanguagePopup,
                isDark: isDark,
              ),

              _menuToggle(
                icon: Icons.dark_mode_outlined,
                title: "Theme",
                value: isDark,
                trailingText: isDark ? "Dark" : "Light",
                onChanged: (v) => themeProvider.setTheme(v),
                isDark: isDark,
              ),

              const SizedBox(height: 25),

              // ===========================
              // Support
              // ===========================
              Text("Support",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )),
              const SizedBox(height: 10),

              _menuAction(
                icon: Icons.support_agent_outlined,
                title: "Help & Support",
                onTap: () {},
                isDark: isDark,
              ),
              _menuAction(
                icon: Icons.email_outlined,
                title: "Contact us",
                onTap: () {},
                isDark: isDark,
              ),
              _menuAction(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy policy",
                onTap: () {},
                isDark: isDark,
              ),
              _menuAction(
                icon: Icons.lock_outline,
                title: "Change password",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                  );
                },
                isDark: isDark,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // Toggle item
  // ===========================
  Widget _menuToggle({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: isDark ? Colors.white : Colors.black87),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          const SizedBox(width: 10),

          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // ===========================
  // Action item
  // ===========================
  Widget _menuAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    String trailing = "",
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isDark ? Colors.white : Colors.black87),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            if (trailing.isNotEmpty)
              Text(
                trailing,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
