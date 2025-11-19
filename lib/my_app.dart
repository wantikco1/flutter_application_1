// lib/my_app.dart
import 'package:flutter/material.dart';
import 'app/app.dart'; // Наш главный экспортный файл

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'evgeny tikhonov',
      theme: AppTheme.lightTheme, // [cite: 151]
      routeInformationProvider: router.routeInformationProvider, // [cite: 152]
      routeInformationParser: router.routeInformationParser, // [cite: 153]
      routerDelegate: router.routerDelegate, // [cite: 154]
    );
  }
}