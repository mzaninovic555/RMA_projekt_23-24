import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medicationapp/firebase_options.dart';
import 'package:medicationapp/pages/home_page.dart';
import 'package:medicationapp/services/backup_service.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/services/notification_service.dart';
import 'package:medicationapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // init local data store
  LocalDataService localDataService =
      await LocalDataService.initLocalDataService();
  localDataService.insertDefaults();

  // init backup service
  BackupService.initializeBackupCron();

  // init notification service
  await Notifications.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(localDataService),
      child: MedicationApp(localDataService),
    ),
  );
}

class MedicationApp extends StatelessWidget {
  final LocalDataService localDataService;

  const MedicationApp(this.localDataService, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(localDataService),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
