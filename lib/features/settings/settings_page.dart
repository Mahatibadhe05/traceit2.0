import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'permission_page.dart';
import 'privacy_data_page.dart';
import 'help_faq_page.dart';
import 'contact_support_page.dart';
import 'about_page.dart';

import '../../core/utils/responsive.dart';
import '../../services/auth_service.dart';
import '../auth/login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool soundVibrationEnabled = true;

  final Color primaryBlue = const Color(0xFF1769FF);
  final Color darkBlue = const Color(0xFF14244A);

  final AuthService _authService = AuthService();

  void showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature will be available soon."),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    try {
      await _authService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to log out. Please try again.",
          ),
        ),
      );
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            "Log Out",
            style: TextStyle(
              fontSize: Responsive.font(
                dialogContext,
                4.6,
              ),
            ),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(
              fontSize: Responsive.font(
                dialogContext,
                3.8,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await _logout();
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(
            color: darkBlue,
            fontSize: Responsive.font(
              context,
              6.67,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================

      body: ListView(
        padding: EdgeInsets.fromLTRB(
          Responsive.w(
            context,
            16 / 390,
          ),
          Responsive.h(
            context,
            10 / 844,
          ),
          Responsive.w(
            context,
            16 / 390,
          ),
          Responsive.h(
            context,
            30 / 844,
          ),
        ),
        children: [
          // ================= ACCOUNT =================

          _sectionTitle(
            context,
            "ACCOUNT",
          ),

          _settingsCard(
            context: context,
            children: [
              // USER PROFILE

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    6 / 844,
                  ),
                ),
                leading: CircleAvatar(
                  radius: Responsive.radius(
                    context,
                    28,
                  ),
                  backgroundColor: const Color(
                    0xFFE4EDFF,
                  ),
                  child: Icon(
                    Icons.person,
                    color: primaryBlue,
                    size: Responsive.font(
                      context,
                      8.2,
                    ),
                  ),
                ),
                title: Text(
                  "User Profile",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "View and edit your profile",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfilePage(),
                    ),
                  );
                },
              ),

              Divider(
                height: Responsive.h(
                  context,
                  1 / 844,
                ),
              ),

              // EDIT PROFILE

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.person_outline,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.15,
                  ),
                ),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(
            height: Responsive.h(
              context,
              22 / 844,
            ),
          ),

          // ================= APP PREFERENCES =================

          _sectionTitle(
            context,
            "APP PREFERENCES",
          ),

          _settingsCard(
            context: context,
            children: [
              // NOTIFICATIONS

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.notifications_none,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    7.18,
                  ),
                ),
                title: Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Manage alerts and updates",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Switch(
                  value: notificationsEnabled,
                  activeThumbColor: primaryBlue,
                  activeTrackColor: const Color(
                    0xFF8DB5FF,
                  ),
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ),

              Divider(
                height: Responsive.h(
                  context,
                  1 / 844,
                ),
              ),

              // SOUND & VIBRATION

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.volume_up_outlined,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Sound & Vibration",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Sound and vibration settings",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Switch(
                  value: soundVibrationEnabled,
                  activeThumbColor: primaryBlue,
                  activeTrackColor: const Color(
                    0xFF8DB5FF,
                  ),
                  onChanged: (value) {
                    setState(() {
                      soundVibrationEnabled = value;
                    });
                  },
                ),
              ),

              Divider(
                height: Responsive.h(
                  context,
                  1 / 844,
                ),
              ),

              // DARK MODE

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.dark_mode_outlined,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Use dark theme",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Switch(
                  value: false,
                  activeThumbColor: primaryBlue,
                  activeTrackColor: const Color(
                    0xFF8DB5FF,
                  ),
                  onChanged: (value) {
                    // Dark mode will be implemented later.
                  },
                ),
              ),
            ],
          ),

          SizedBox(
            height: Responsive.h(
              context,
              22 / 844,
            ),
          ),

          // ================= PRIVACY & SECURITY =================

          _sectionTitle(
            context,
            "PRIVACY & SECURITY",
          ),

          _settingsCard(
            context: context,
            children: [
              // PERMISSION MANAGEMENT

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.verified_user_outlined,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Permission Management",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Manage all app permissions",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PermissionPage(),
                    ),
                  );
                },
              ),

              Divider(
                height: Responsive.h(
                  context,
                  1 / 844,
                ),
              ),

              // PRIVACY & DATA

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.shield_outlined,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Privacy & Data",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Learn how we protect your data",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PrivacyDataPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(
            height: Responsive.h(
              context,
              22 / 844,
            ),
          ),

          // ================= SUPPORT =================

          _sectionTitle(
            context,
            "SUPPORT",
          ),

          _settingsCard(
            context: context,
            children: [
              // HELP & FAQ

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Help & FAQ",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Find answers to common questions",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const HelpFaqPage(),
                    ),
                  );
                },
              ),

              Divider(
                height: Responsive.h(
                  context,
                  1 / 844,
                ),
              ),

              // CONTACT SUPPORT

              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.chat_bubble_outline,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "Contact Support",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "We're here to help",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ContactSupportPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(
            height: Responsive.h(
              context,
              22 / 844,
            ),
          ),

          // ================= ABOUT =================

          _sectionTitle(
            context,
            "ABOUT",
          ),

          _settingsCard(
            context: context,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(
                    context,
                    16 / 390,
                  ),
                  vertical: Responsive.h(
                    context,
                    4 / 844,
                  ),
                ),
                leading: Icon(
                  Icons.info_outline,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6.92,
                  ),
                ),
                title: Text(
                  "About TraceIt",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.33,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: primaryBlue,
                  size: Responsive.font(
                    context,
                    6,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AboutPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(
            height: Responsive.h(
              context,
              28 / 844,
            ),
          ),

          // ================= LOG OUT =================

          SizedBox(
            height: Responsive.h(
              context,
              52 / 844,
            ),
            child: OutlinedButton.icon(
              onPressed: _showLogoutConfirmation,
              icon: Icon(
                Icons.logout,
                size: Responsive.font(
                  context,
                  5.64,
                ),
              ),
              label: Text(
                "Log Out",
                style: TextStyle(
                  fontSize: Responsive.font(
                    context,
                    4.1,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(
                      context,
                      14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: Responsive.h(
              context,
              20 / 844,
            ),
          ),

          // ================= PROJECT NOTE =================

          Center(
            child: Text(
              "TraceIt • Never lose what matters.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.font(
                  context,
                  3.08,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: Responsive.w(
          context,
          4 / 390,
        ),
        bottom: Responsive.h(
          context,
          9 / 844,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: primaryBlue,
          fontSize: Responsive.font(
            context,
            3.59,
          ),
          fontWeight: FontWeight.bold,
          letterSpacing: Responsive.w(
            context,
            0.5 / 390,
          ),
        ),
      ),
    );
  }

  // ================= SETTINGS CARD =================

  Widget _settingsCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(
            context,
            18,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(
              alpha: 0.06,
            ),
            blurRadius: Responsive.w(
              context,
              12 / 390,
            ),
            offset: Offset(
              0,
              Responsive.h(
                context,
                4 / 844,
              ),
            ),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}