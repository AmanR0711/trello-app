// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../onboarding/model/theme_type.dart';

final AppThemes = <ThemeType, ThemeData>{
  ThemeType.light: ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
    ),
    primaryColor: Colors.red,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.amber,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
    ),
  ),
  ThemeType.dark: ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.grey.shade700,
    primaryColor: Colors.red,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.amber,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
    ),
  ),
};
