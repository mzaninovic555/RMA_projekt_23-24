import 'package:flutter/material.dart';
import 'package:medicationapp/pages/home_page.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      // initialRoute: '/',
      // routes: {
      // },
    );
  }
}
