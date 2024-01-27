import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

/// Class for a group of medications all sharing a certain time.
class ReminderGroup {
  String title;
  TimeOfDay timeOfReminder;
  List<MedicationType> medications;
  Color? color;

  ReminderGroup(this.title, this.timeOfReminder, this.medications, [this.color]);
}

/// Class for a singular medication item which is not grouped.
class ReminderItem {
  String title;
  TimeOfDay timeOfReminder;
  MedicationType medication;

  ReminderItem(this.title, this.timeOfReminder, this.medication);
}
