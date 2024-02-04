import 'package:cron/cron.dart';
import 'package:medicationapp/auth/auth.dart';
import 'package:medicationapp/services/database.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/services/medication_service.dart';
import 'package:medicationapp/services/reminder_service.dart';

import '../common/backup_wrapper.dart';

class BackupService {
  static final _cron = Cron();

  static void initializeBackupCron() {
    _cron.schedule(Schedule.parse('1 0 * * *'), () async {
      var localDataService = await LocalDataService.initLocalDataService();
      if (!localDataService.getIsBackupEnabled() ||
          Auth().currentUser == null) {
        return;
      }
      await backupData();
    });
  }

  static Future<void> backupData() async {
    await RepositoryService().backupRemindersAndMedication();
  }

  static Future<void> fetchLatestBackup() async {
    BackupWrapper? latestData = await RepositoryService().fetchLatestBackup();
    if (latestData == null) {
      return;
    }
    MedicationService.setMedication(latestData.medication);
    ReminderService.setReminderList(latestData.reminderGroups);
  }
}
