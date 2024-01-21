import 'package:flutter/material.dart';
import 'package:medicationapp/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  void setIsDarkMode(bool isDark) {
    if (isDark) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
