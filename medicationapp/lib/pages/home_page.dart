import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:medicationapp/pages/medication/medication.dart';
import 'package:medicationapp/pages/pharmacies/pharmacies.dart';
import 'package:medicationapp/pages/reminder_list/reminder_list.dart';
import 'package:medicationapp/pages/settings/settings.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/theme/theme.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  late final LocalDataService localDataService;
  late final Map<String, Widget> pages;

  @override
  void initState() {
    super.initState();
    LocalDataService.initLocalDataService().then((value) {

      setState(() {
        localDataService = value;
        pages = {
          'Reminders': const ReminderList(),
          'Medication': const Medication(),
          'Pharmacies': const Pharmacies(),
          'Settings': Settings(localDataService),
        };
      });
      localDataService.insertDefaults();
      Provider.of<ThemeProvider>(context, listen: false)
          .setIsDarkMode(localDataService.getIsDarkTheme());
    });
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          pages.keys.elementAt(selectedIndex),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: pages.values.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: navigateBottomBar,
            tabBorderRadius: 28.0,
            rippleColor: Theme.of(context).hoverColor,
            gap: 8.0,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.medication,
                text: 'Medication',
              ),
              GButton(
                icon: Icons.map,
                text: 'Pharmacies',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
