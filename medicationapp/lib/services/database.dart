import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicationapp/common/backup_wrapper.dart';
import 'package:medicationapp/services/medication_service.dart';
import 'package:medicationapp/services/reminder_service.dart';

import '../auth/auth.dart';

class RepositoryService {
  final CollectionReference backupCollection = FirebaseFirestore.instance
      .collection('backups')
      .withConverter<BackupWrapper>(
        fromFirestore: BackupWrapper.fromFirestore,
        toFirestore: (value, options) => value.toJson(),
      );

  Future<void> backupRemindersAndMedication() async {
    String? uid = Auth().currentUser?.uid;
    if (uid == null) {
      return;
    }

    BackupWrapper wrapper = BackupWrapper(
      Timestamp.now(),
      ReminderService.getReminderGroups(),
      MedicationService.getMedication(),
      uid,
    );

    await backupCollection.add(wrapper);
  }

  Future<BackupWrapper?> fetchLatestBackup() async {
    String? uid = Auth().currentUser?.uid;
    if (uid == null) {
      throw Exception("Unauthorized");
    }

    final docSnap = await backupCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    final backup = docSnap.docs.first.data() is BackupWrapper
        ? docSnap.docs.first.data() as BackupWrapper
        : null;

    return Future.value(backup);
  }
}
