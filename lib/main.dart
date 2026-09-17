import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/login_page.dart';
import 'features/main/main_screen.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load the saved light/dark mode before the app starts.
  await themeController.loadSavedTheme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TraceIt',

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          themeMode: themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // Show Splash Screen first.
          home: const SplashScreen(),

          // Splash Screen moves here after 2 seconds.
          routes: {
            '/auth': (_) => const AuthGate(),
          },
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase is checking the current authentication state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in.
        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        // User is not logged in.
        return const LoginPage();
      },
    );
  }
}