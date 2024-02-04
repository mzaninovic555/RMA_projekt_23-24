import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:medicationapp/services/local_data_service.dart';

import '../pages/reminder_list/reminder_data.dart';
import 'medication_service.dart';
import 'notification_service.dart';

class ReminderService {
  static List<ReminderGroup> mockMeds = [
    ReminderGroup(
        'Morning',
        TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1),
        [
          MedicationService.mockMedication[0],
          MedicationService.mockMedication[1],
          MedicationService.mockMedication[2],
        ]),
    ReminderGroup(
        'Evening',
        TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 2),
        [
          MedicationService.mockMedication[2],
        ]),
    ReminderGroup(
        'Night',
        TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 3),
        []),
  ];

  static List<ReminderGroup> _reminderList = [];

  static void setReminderList(List<ReminderGroup>? newList) {
    _reminderList = newList ?? [];
  }

  static List<ReminderGroup> getReminderGroups() {
    return _reminderList;
  }

  static void removeFromReminderGroup(int groupIndex,
      MedicationType medicationType, LocalDataService localDataService) {
    _reminderList[groupIndex].medications.remove(medicationType);
    _saveToPreferences(localDataService);
  }

  static void addMedicationItemsToGroup(int groupIndex,
      List<MedicationType> items, LocalDataService localDataService) {
    _reminderList[groupIndex].medications.addAll(items);
    _saveToPreferences(localDataService);
  }

  static void addNewReminderGroup(
      ReminderGroup reminderGroup, LocalDataService localDataService) {
    _reminderList.add(reminderGroup);
    _saveToPreferences(localDataService);
  }

  static void editReminderGroup(ReminderGroup oldReminderGroup,
      ReminderGroup newReminderGroup, LocalDataService localDataService) {
    var indexOf = _reminderList.indexOf(oldReminderGroup);
    _reminderList[indexOf] = newReminderGroup;
    _saveToPreferences(localDataService);
  }

  static void removeReminderGroup(
      ReminderGroup reminderGroup, LocalDataService localDataService) {
    _reminderList.remove(reminderGroup);
    _saveToPreferences(localDataService);
  }

  static void removeMedicationFromReminders(
      MedicationType medication, LocalDataService localDataService) {
    for (var reminder in _reminderList) {
      reminder.medications.remove(medication);
      _saveToPreferences(localDataService);
    }
  }

  static void takeMedicationInGroup(
      ReminderGroup reminderGroup, LocalDataService localDataService) {
    var indexOf = _reminderList.indexOf(reminderGroup);

    _reminderList[indexOf].medications =
        _reminderList[indexOf].medications.map((medication) {
      medication.quantityRemaining -= medication.dosage.toInt();
      return medication;
    }).toList();
    _saveToPreferences(localDataService);
  }

  static void sendNotifications() {
    TimeOfDay now = TimeOfDay.now();
    for (final group in _reminderList) {
      if (group.timeOfReminder == now) {
        _createAndSendNotification(group);
      }
    }
  }

  static void _createAndSendNotification(ReminderGroup group) {
    String notificationBody = '';
    for (int i = 0; i < group.medications.length; i++) {
      if (i == group.medications.length - 1) {
        notificationBody += group.medications[i].name;
      } else {
        notificationBody += '${group.medications[i].name}, ';
      }
    }
    Notifications.showNotification(title: group.title, body: notificationBody);
  }

  static void _saveToPreferences(LocalDataService localDataService) {
    var reminderGroupJson = json.encode(_reminderList);
    localDataService.setReminderGroups(reminderGroupJson);
  }

  static Future<void> getFromPreferences(
      LocalDataService localDataService) async {
    var fromStorage = localDataService.getReminderGroups();

    if (fromStorage == null) {
      _reminderList = [];
      return;
    }

    _reminderList = (json.decode(fromStorage) as List)
        .map((groupJson) => ReminderGroup.fromJson(groupJson))
        .toList();
  }
}
