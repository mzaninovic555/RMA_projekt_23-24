import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:uuid/uuid.dart';

/// Class for a group of medications all sharing a certain time.
class ReminderGroup {
  String id;
  String title;
  TimeOfDay timeOfReminder;
  List<MedicationType> medications;

  ReminderGroup(this.title, this.timeOfReminder, this.medications) : id = Uuid().v4();
  ReminderGroup.withId(this.id, this.title, this.timeOfReminder, this.medications);

  factory ReminderGroup.fromJson(dynamic json) {
    if (json['medications'] != null) {
      var medicationObjsJson = json['medications'] as List;
      List<MedicationType> medications = medicationObjsJson
          .map((medicationJson) => MedicationType.fromJson(medicationJson))
          .toList();

      return ReminderGroup.withId(
        json['id'] as String,
        json['title'] as String,
        TimeOfDay.fromDateTime(DateTime.parse(json['timeOfReminder'])),
        medications,
      );
    }

    return ReminderGroup.withId(
      json['id'] as String,
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
      'id': id,
      'title': title,
      'timeOfReminder': dateTimeTemp.toIso8601String(),
      'medications': medications
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderGroup &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
