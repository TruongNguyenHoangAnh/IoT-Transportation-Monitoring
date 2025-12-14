import 'dart:io';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  File? _avatar;
  bool _isNotificationEnabled = true;
  String _language = "en";

  File? get avatar => _avatar;
  bool get isNotificationEnabled => _isNotificationEnabled;
  String get language => _language;

  void setAvatar(File file) {
    _avatar = file;
    notifyListeners();
  }

  void toggleNotification() {
    _isNotificationEnabled = !_isNotificationEnabled;
    notifyListeners();
  }

  void setLanguage(String code) {
    _language = code;
    notifyListeners();
  }
}
