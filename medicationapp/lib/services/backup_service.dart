import 'package:cron/cron.dart';
import 'package:medicationapp/auth/auth.dart';
import 'package:medicationapp/services/local_data_service.dart';

class BackupService {
  static final _cron = Cron();

  static void initializeBackupCron() {
    _cron.schedule(Schedule.parse('1 0 * * *'), () async {
      var localDataService = await LocalDataService.initLocalDataService();
      if (!localDataService.getIsBackupEnabled() ||
          Auth().currentUser == null) {
        return;
      }
      await _backupData();
    });
  }

  static Future<void> _backupData() async {
    await null;
  }
}
