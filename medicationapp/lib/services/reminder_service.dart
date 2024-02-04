import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

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

  static set setReminderList(List<ReminderGroup>? newList) {
    _reminderList = newList ?? [];
  }

  static List<ReminderGroup> getReminderGroups() {
    return _reminderList;
  }

  static void removeFromReminderGroup(
      int groupIndex, MedicationType medicationType) {
    _reminderList[groupIndex].medications.remove(medicationType);
  }

  static void addMedicationItemsToGroup(
      int groupIndex, List<MedicationType> items) {
    _reminderList[groupIndex].medications.addAll(items);
  }

  static void addNewReminderGroup(ReminderGroup reminderGroup) {
    _reminderList.add(reminderGroup);
  }

  static void editReminderGroup(
      ReminderGroup oldReminderGroup, ReminderGroup newReminderGroup) {
    var indexOf = _reminderList.indexOf(oldReminderGroup);
    _reminderList[indexOf] = newReminderGroup;
  }

  static void removeReminderGroup(ReminderGroup reminderGroup) {
    _reminderList.remove(reminderGroup);
  }

  static void removeMedicationFromReminders(MedicationType medication) {
    for (var reminder in _reminderList) {
      reminder.medications.remove(medication);
    }
  }

  static void takeMedicationInGroup(ReminderGroup reminderGroup) {
    var indexOf = _reminderList.indexOf(reminderGroup);

    _reminderList[indexOf].medications =
        _reminderList[indexOf].medications.map((medication) {
      medication.quantityRemaining -= medication.dosage.toInt();
      return medication;
    }).toList();
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
}
