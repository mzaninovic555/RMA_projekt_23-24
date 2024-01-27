import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

import '../pages/reminder_list/reminder_data.dart';
import 'medication_service.dart';

class ReminderService {
  static List<ReminderGroup> mockMeds = [
    ReminderGroup('Morning', TimeOfDay.now(), [
      MedicationService.mockMedication[0],
      MedicationService.mockMedication[1],
      MedicationService.mockMedication[2],
    ]),
    ReminderGroup('Evening', TimeOfDay.now(), [
      MedicationService.mockMedication[2],
    ]),
    ReminderGroup('Night', TimeOfDay.now(), []),
  ];
  
  static List<ReminderGroup> getReminderGroups() {
    return mockMeds;
  }
  
  static void removeFromReminderGroup(int groupIndex, MedicationType medicationType) {
    mockMeds[groupIndex].medications.remove(medicationType);
  }

  static void addMedicationItemsToGroup(int groupIndex, List<MedicationType> items) {
    mockMeds[groupIndex].medications.addAll(items);
  }

  static void addNewReminderGroup(ReminderGroup reminderGroup) {
    mockMeds.add(reminderGroup);
  }

  static void removeReminderGroup(ReminderGroup reminderGroup) {
    mockMeds.remove(reminderGroup);
  }

  static void takeMedicationInGroup(ReminderGroup reminderGroup) {
    var indexOf = mockMeds.indexOf(reminderGroup);

    mockMeds[indexOf].medications = mockMeds[indexOf].medications.map((medication) {
      medication.quantityRemaining -= medication.dosage.toInt();
      return medication;
    }).toList();
  }
}
