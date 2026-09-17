import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('darkMode') ?? false;

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }
}

// One shared controller for the whole app.
final ThemeController themeController = ThemeController();