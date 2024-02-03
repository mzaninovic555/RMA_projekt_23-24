import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicationapp/pages/auth/auth_page.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../auth/auth.dart';

class Settings extends StatefulWidget {
  final LocalDataService localDataService;

  const Settings(this.localDataService, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? user = Auth().currentUser;

  static const TextStyle _settingsTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Divider(height: 1.0),
        _settingsElement(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dark mode',
                style: _settingsTextStyle,
              ),
              Switch(
                value: widget.localDataService.getIsDarkTheme(),
                onChanged: (value) => {
                  setState(() {
                    widget.localDataService.setIsDarkTheme(value);
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setIsDarkMode(
                            widget.localDataService.getIsDarkTheme());
                  })
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1.0),
        authWidget(140),
        const Divider(height: 1.0),
      ],
    );
  }

  SizedBox _settingsElement(Widget child, {double height = 70}) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: child,
      ),
    );
  }

  Widget authWidget(double height) {
    bool isSignedIn = user != null;

    if (isSignedIn) {
      return _settingsElement(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(user!.email!, style: _settingsTextStyle),
          ElevatedButton(
            onPressed: () async {
              await Auth().signOut();
              setState(() {
                user = Auth().currentUser;
              });
            },
            child: const Text('Sign out', style: _settingsTextStyle),
          ),
        ],
      ));
    }

    return _settingsElement(
      height: 120,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('User not signed in', style: _settingsTextStyle),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthWidget(true)));
                  setState(() {
                    user = Auth().currentUser;
                  });
                },
                child: const Text('Login', style: _settingsTextStyle),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthWidget(false)));
                  setState(() {
                    user = Auth().currentUser;
                  });
                },
                child: const Text('Register', style: _settingsTextStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
