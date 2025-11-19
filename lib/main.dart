// lib/main.dart
import 'package:flutter/material.dart';
import 'di/di.dart'; // Наш DI
import 'my_app.dart'; // Наш класс приложения

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // [cite: 136]
  await setupLocator(); // [cite: 137]
  
  FlutterError.onError = (details) {
    return talker.handle(details.exception, details.stack); // [cite: 139]
  };

  runApp(AppName()); // [cite: 141]
}