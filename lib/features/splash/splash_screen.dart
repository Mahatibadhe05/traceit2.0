import 'package:flutter/material.dart';
import '../auth/login_page.dart';

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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      },
    );
  }

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