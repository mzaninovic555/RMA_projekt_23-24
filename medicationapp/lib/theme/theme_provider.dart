import 'package:flutter/material.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;


  ThemeProvider(LocalDataService localDataService) {
    _themeData = localDataService.getIsDarkTheme() ? darkMode : lightMode;
  }

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
