import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/traceit_logo.png',
                width: screenWidth * 0.28,
              ),

              const SizedBox(height: 24),

              const Text(
                'TraceIt',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Never lose what matters.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 60),

              const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}