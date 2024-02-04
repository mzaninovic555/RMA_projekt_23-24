import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationapp/pages/medication/medication_data.dart';
import 'package:medicationapp/pages/reminder_list/reminder_data.dart';
import 'package:medicationapp/services/medication_service.dart';
import 'package:medicationapp/services/reminder_service.dart';

import '../auth/auth.dart';

class RepositoryService {
  final CollectionReference reminderCollection = FirebaseFirestore.instance
      .collection('reminder')
      .withConverter<ReminderGroup>(
        fromFirestore: (snapshot, options) =>
            ReminderGroup.fromJson(snapshot.data()),
        toFirestore: (value, options) => value.toJson(),
      );

  final CollectionReference medicationCollection = FirebaseFirestore.instance
      .collection('medication')
      .withConverter<MedicationType>(
        fromFirestore: (snapshot, options) =>
            MedicationType.fromJson(snapshot.data()),
        toFirestore: (value, options) => value.toJson(),
      );

  Future<void> backupMedication() async {
    String? uid = Auth().currentUser?.uid;
    if (uid == null) {
      return;
    }
    MedicationService.getMedication().forEach((medication) async {
      await medicationCollection.add(medication);
    });
  }

  Future<void> backupReminders() async {
    String? uid = Auth().currentUser?.uid;
    if (uid == null) {
      return;
    }
    ReminderService.getReminderGroups().forEach((group) async {
      await reminderCollection.add(group);
    });
  }
}
