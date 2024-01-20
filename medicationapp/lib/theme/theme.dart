import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.red,
  hoverColor: Colors.grey[400],
  colorScheme: ColorScheme.light(
    primary: Colors.red,
    primaryContainer: Colors.red[700],
    secondary: Colors.deepOrange[200]!,
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red,
    titleTextStyle: TextStyle(
      color: Colors.black
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  primarySwatch: Colors.red,
  hoverColor: Colors.grey[900],
  colorScheme: ColorScheme.dark(
    primary: Colors.red[900]!,
    primaryContainer: Colors.redAccent[400],
    secondary: Colors.redAccent,
  ),
  scaffoldBackgroundColor: Colors.grey[850],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
);
