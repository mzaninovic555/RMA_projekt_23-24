import 'package:flutter/material.dart';
import 'package:medicationapp/pages/home_page.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/services/notification_service.dart';
import 'package:medicationapp/theme/theme_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init local data store
  LocalDataService localDataService =
      await LocalDataService.initLocalDataService();
  localDataService.insertDefaults();

  // ask user for notification access
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

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
