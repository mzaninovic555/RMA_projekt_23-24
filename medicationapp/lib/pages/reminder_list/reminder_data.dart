import 'package:flutter/material.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth.dart';

/// Class for a group of medications all sharing a certain time.
class ReminderGroup {
  String id;
  String title;
  TimeOfDay timeOfReminder;
  List<MedicationType> medications;
  String? userId;

  ReminderGroup(this.title, this.timeOfReminder, this.medications)
      : id = Uuid().v4(),
        userId = Auth().currentUser?.uid;

  ReminderGroup.withId(
      this.id, this.title, this.timeOfReminder, this.medications)
      : userId = Auth().currentUser?.uid;

  ReminderGroup.withIdAndUserId(
      this.id, this.title, this.timeOfReminder, this.medications, this.userId);

  factory ReminderGroup.fromJson(dynamic json) {
    if (json['medications'] != null) {
      var medicationObjsJson = json['medications'] as List;
      List<MedicationType> medications = medicationObjsJson
          .map((medicationJson) => MedicationType.fromJson(medicationJson))
          .toList();

      return ReminderGroup.withIdAndUserId(
        json['id'] as String,
        json['title'] as String,
        TimeOfDay.fromDateTime(DateTime.parse(json['timeOfReminder'])),
        medications,
        json['userId'] is String ? json['userId'] as String : null,
      );
    }

    return ReminderGroup.withIdAndUserId(
      json['id'] as String,
      json['title'] as String,
      TimeOfDay.fromDateTime(DateTime.parse(json['timeOfReminder'])),
      [],
      json['userId'] is String ? json['userId'] as String : null,
    );
  }

  Map<String, Object?> toJson() {
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
      'medications': medications,
      'userId': userId,
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
