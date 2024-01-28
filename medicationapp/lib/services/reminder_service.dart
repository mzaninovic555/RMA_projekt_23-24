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
            hour: TimeOfDay
                .now()
                .hour, minute: TimeOfDay
            .now()
            .minute + 1),
        [
          MedicationService.mockMedication[0],
          MedicationService.mockMedication[1],
          MedicationService.mockMedication[2],
        ]),
    ReminderGroup(
        'Evening',
        TimeOfDay(
            hour: TimeOfDay
                .now()
                .hour, minute: TimeOfDay
            .now()
            .minute + 2),
        [
          MedicationService.mockMedication[2],
        ]),
    ReminderGroup(
        'Night',
        TimeOfDay(
            hour: TimeOfDay
                .now()
                .hour, minute: TimeOfDay
            .now()
            .minute + 3),
        []),
  ];

  static List<ReminderGroup> getReminderGroups() {
    return mockMeds;
  }

  static void removeFromReminderGroup(int groupIndex,
      MedicationType medicationType) {
    mockMeds[groupIndex].medications.remove(medicationType);
  }

  static void addMedicationItemsToGroup(int groupIndex,
      List<MedicationType> items) {
    mockMeds[groupIndex].medications.addAll(items);
  }

  static void addNewReminderGroup(ReminderGroup reminderGroup) {
    mockMeds.add(reminderGroup);
  }

  static void editReminderGroup(ReminderGroup oldReminderGroup,
      ReminderGroup newReminderGroup) {
    var indexOf = mockMeds.indexOf(oldReminderGroup);
    mockMeds[indexOf] = newReminderGroup;
  }

  static void removeReminderGroup(ReminderGroup reminderGroup) {
    mockMeds.remove(reminderGroup);
  }

  static void takeMedicationInGroup(ReminderGroup reminderGroup) {
    var indexOf = mockMeds.indexOf(reminderGroup);

    mockMeds[indexOf].medications =
        mockMeds[indexOf].medications.map((medication) {
          medication.quantityRemaining -= medication.dosage.toInt();
          return medication;
        }).toList();
  }

  static void sendNotifications() {
    TimeOfDay now = TimeOfDay.now();
    for (final group in mockMeds) {
      if (group.timeOfReminder == now) {
        String body = group.medications
            .map((medication) => "${medication.name} ")
            .reduce((value, element) => value + element);
        Notifications.showNotification(title: group.title, body: body);
      }
    }
  }
}
