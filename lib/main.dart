import 'package:flutter/material.dart';
import 'features/alerts/alerts_screen.dart';

void main() {
  runApp(const TraceItAlertsApp());
}

class TraceItAlertsApp extends StatelessWidget {
  const TraceItAlertsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TraceIt Alerts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),
        useMaterial3: true,
      ),
      home: const AlertsScreen(),
    );
  }
}