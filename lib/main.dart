import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parker/firebase_options.dart';
import 'package:parker/screens/splash_screen.dart';
import 'package:parker/services/analytics_service.dart';
import 'package:parker/services/notification_service.dart';


final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 21, 175, 247),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();
  await AnalyticsService.logAppOpened();

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
