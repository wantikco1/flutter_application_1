// lib/app/theme/theme_data.dart
import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ThemeColors.white,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      // таким же образом сюда можно добавить и темы других виджетов
    );
  }
}

final _colorScheme = ColorScheme.fromSeed(
  seedColor: ThemeColors.accent,
);

final _appBarTheme = AppBarTheme(
  toolbarHeight: 50,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: true,
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ThemeColors.white,
  ),
  backgroundColor: ThemeColors.black,
);