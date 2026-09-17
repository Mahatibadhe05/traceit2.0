import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/auth',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use the saved theme directly.
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : Colors.white,
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

              Text(
                'TraceIt',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Never lose what matters.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF6B7280),
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