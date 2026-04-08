import 'package:flutter/material.dart';

void main() {
  runApp(const ParkerApp());
}

class ParkerApp extends StatelessWidget {
  const ParkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
     // home: const SplashScreen(),
    );
  }
}

