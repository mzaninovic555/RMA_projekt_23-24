import 'package:flutter/material.dart';

class TimeFormatter {
  static String formatTimeOfDay(BuildContext context, TimeOfDay timeOfDay) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(timeOfDay);
  }
}
