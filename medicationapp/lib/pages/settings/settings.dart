import 'package:flutter/material.dart';
import 'package:medicationapp/services/local_data_service.dart';
import 'package:medicationapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final LocalDataService localDataService;

  const Settings(this.localDataService, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const TextStyle _settingsTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Divider(height: 1.0),
        SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
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
        ),
        const Divider(height: 1.0),
        Container(
          height: 50,
        ),
        const Divider(height: 1.0),
        Container(
          height: 50,
        ),
        const Divider(height: 1.0),
        Container(
          height: 50,
        ),
        const Divider(height: 1.0),
      ],
    );
  }
}
