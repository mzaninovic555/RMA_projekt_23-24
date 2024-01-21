import 'package:flutter/material.dart';
import 'package:medicationapp/pages/home_page.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/theme/theme.dart';
import 'package:medicationapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MedicationApp(),
    ),
  );
}

class MedicationApp extends StatelessWidget {
  const MedicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LocalDataService.initLocalDataService(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var localDataService = snapshot.data;
          localDataService!.insertDefaults();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(localDataService),
            theme: localDataService.getIsDarkTheme() ? lightMode : darkMode,
          );
        });
  }
}
