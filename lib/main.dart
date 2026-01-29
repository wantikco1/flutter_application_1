import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // [cite: 10]
import 'di/di.dart'; 
import 'my_app.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB-tuNnEUdLCJSfh_Fzi0tRAufAv_FYvAE",
      authDomain: "flutter-tikhonov.firebaseapp.com",
      projectId: "flutter-tikhonov",
      storageBucket: "flutter-tikhonov.firebasestorage.app",
      messagingSenderId: "816166042369",
      appId: "1:816166042369:web:dfd3d3105b95b6bafcf900",
      measurementId: "G-209VVZ94KZ",
    ),
  ); 

  await setupLocator(); 

  FlutterError.onError = (details) {
    return talker.handle(details.exception, details.stack); 
  };

  runApp(const AppName()); 
}