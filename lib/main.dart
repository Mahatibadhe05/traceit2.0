import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TraceItApp());
}

class TraceItApp extends StatelessWidget {
  const TraceItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TraceIt',

      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}