// lib/main.dart

import 'package:flutter/material.dart';
import 'package:loopin_v2/screens/host/interest.dart';
// Make sure to import the file where your MobileNoPage is located
import 'package:loopin_v2/screens/login/mobilescreen.dart';

// Import the new splash screen
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      theme: ThemeData(
        // You can define a theme for your app here
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // A dark theme might fit your UI
      ),
      debugShowCheckedModeBanner: false, // Hides the debug banner
      // Set the splash screen as the initial screen of the app
      home: SplashScreen(),
    );
  }
}
