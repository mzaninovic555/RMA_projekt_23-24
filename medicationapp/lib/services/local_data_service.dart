import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  static const String _darkMode = 'darkMode';
  static const String _isBackupEnabled = 'backupEnabled';
  static const String _reminderData = 'reminderData';

  final SharedPreferences preferences;

  LocalDataService(this.preferences);

  static Future<LocalDataService> initLocalDataService() async {
    var dataStorage = await SharedPreferences.getInstance();
    return LocalDataService(dataStorage);
  }

  void insertDefaults() {
    if (preferences.getBool(_darkMode) == null) {
      bool isDarkMode =
          SchedulerBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark;
      preferences.setBool(_darkMode, isDarkMode);
    }

    if (preferences.getBool(_isBackupEnabled) == null) {
      preferences.setBool(_isBackupEnabled, true);
    }

    if (preferences.getString(_reminderData) == null) {

    }
  }

  bool getIsDarkTheme() {
    return preferences.getBool(_darkMode) ?? false;
  }

  void setIsDarkTheme(bool isDarkMode) {
    preferences.setBool(_darkMode, isDarkMode);
  }

  bool getIsBackupEnabled() {
    return preferences.getBool(_isBackupEnabled) ?? true;
  }

  void setIsBackupEnabled(bool isDarkMode) {
    preferences.setBool(_isBackupEnabled, isDarkMode);
  }


}
