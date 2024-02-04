import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';

import '../pages/reminder_list/reminder_data.dart';

class BackupWrapper {
  Timestamp createdAt;
  List<ReminderGroup> reminderGroups;
  List<MedicationType> medication;
  String userId;

  BackupWrapper(
    this.createdAt,
    this.reminderGroups,
    this.medication,
    this.userId,
  );

  factory BackupWrapper.fromJson(dynamic json) {
    var reminderGroupsJson = json['reminderGroups'] as List;
    List<ReminderGroup> reminderGroups = reminderGroupsJson
        .map((reminderGroupJson) => ReminderGroup.fromJson(reminderGroupJson))
        .toList();

    var medicationObjsJson = json['medication'] as List;
    List<MedicationType> medication = medicationObjsJson
        .map((medicationJson) => MedicationType.fromJson(medicationJson))
        .toList();

    return BackupWrapper(
      json['createdAt'] as Timestamp,
      reminderGroups,
      medication,
      json['userId'] as String,
    );
  }

  factory BackupWrapper.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    var reminderGroupsJson = data['reminderGroups'] as List;
    List<ReminderGroup> reminderGroups = reminderGroupsJson
        .map((reminderGroupJson) => ReminderGroup.fromJson(reminderGroupJson))
        .toList();

    var medicationObjsJson = data['medication'] as List;
    List<MedicationType> medication = medicationObjsJson
        .map((medicationJson) => MedicationType.fromJson(medicationJson))
        .toList();

    return BackupWrapper(
      data['createdAt'] as Timestamp,
      reminderGroups,
      medication,
      data['userId'] as String,
    );
  }

  Map<String, Object?> toJson() {
    List<Map> reminderGroups = this
        .reminderGroups
        .map((reminderGroup) => reminderGroup.toJson())
        .toList();

    List<Map> medication =
        this.medication.map((medication) => medication.toJson()).toList();

    return {
      'createdAt': createdAt,
      'reminderGroups': reminderGroups,
      'medication': medication,
      'userId': userId,
    };
  }
}
