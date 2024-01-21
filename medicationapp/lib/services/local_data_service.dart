import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  static const String _darkMode = 'darkMode';

  final SharedPreferences preferences;

  LocalDataService(this.preferences);

  static Future<LocalDataService> initLocalDataService() async {
    dynamic dataStorage = await SharedPreferences.getInstance();
    return LocalDataService(dataStorage);
  }

  void insertDefaults() {
    if (preferences.getBool(_darkMode) == null) {
      bool isDarkMode = SchedulerBinding.instance.platformDispatcher
          .platformBrightness == Brightness.dark;
      preferences.setBool(_darkMode, isDarkMode);
    }
  }

  bool getIsDarkTheme() {
    return preferences.getBool(_darkMode) ?? false;
  }

  void setIsDarkTheme(bool isDarkMode) {
    preferences.setBool(_darkMode, isDarkMode);
  }
}
