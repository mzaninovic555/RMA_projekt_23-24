import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

/// Class for a group of medications all sharing a certain time.
class ReminderGroup {
  String title;
  TimeOfDay timeOfReminder;
  List<MedicationType> medications;

  ReminderGroup(this.title, this.timeOfReminder, this.medications);

  factory ReminderGroup.fromJson(dynamic json) {
    if (json['medications'] != null) {
      var medicationObjsJson = json['medications'] as List;
      List<MedicationType> medications = medicationObjsJson
          .map((medicationJson) => MedicationType.fromJson(medicationJson))
          .toList();

      return ReminderGroup(
        json['title'] as String,
        TimeOfDay.fromDateTime(DateTime.parse(json['timeOfReminder'])),
        medications,
      );
    }

    return ReminderGroup(
      json['title'] as String,
      TimeOfDay.fromDateTime(DateTime.parse(json['timeOfReminder'])),
      [],
    );
  }

  Map toJson() {
    List<Map> medications =
        this.medications.map((medication) => medication.toJson()).toList();

    var dateTimeTemp = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfReminder.hour,
      timeOfReminder.minute,
    );

    return {
      'title': title,
      'timeOfReminder': dateTimeTemp.toIso8601String(),
      'medications': medications
    };
  }
}
