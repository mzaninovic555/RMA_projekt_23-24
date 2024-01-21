import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  static const String DARK_MODE = 'darkMode';

  final SharedPreferences preferences;

  LocalDataService(this.preferences);

  static Future<LocalDataService> initLocalDataService() async {
    dynamic dataStorage = await SharedPreferences.getInstance();
    return LocalDataService(dataStorage);
  }

  void insertDefaults() {
    if (preferences.getBool(DARK_MODE) == null) {
      bool isDarkMode = SchedulerBinding.instance.platformDispatcher
          .platformBrightness == Brightness.dark;
      preferences.setBool(DARK_MODE, isDarkMode);
    }
  }

  bool getIsDarkTheme() {
    return preferences.getBool(DARK_MODE) ?? false;
  }
}
