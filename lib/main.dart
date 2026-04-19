import 'package:flutter/material.dart';
import 'package:parker/screens/splash_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 21, 175, 247),
  ),
);

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
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
