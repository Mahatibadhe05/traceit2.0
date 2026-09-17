import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class PrivacyDataPage extends StatelessWidget {
  const PrivacyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1769FF);
    const Color darkBlue = Color(0xFF14244A);

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8FAFF);

    final Color appBarColor = isDark
        ? const Color(0xFF121212)
        : Colors.white;

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final Color titleColor = isDark
        ? Colors.white
        : darkBlue;

    final Color descriptionColor = isDark
        ? Colors.white70
        : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,

        title: Text(
          "Privacy & Data",
          style: TextStyle(
            color: titleColor,
            fontSize: Responsive.font(context, 5.65),
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: IconThemeData(
          color: titleColor,
          size: Responsive.font(context, 6),
        ),
      ),

      // ================= BODY =================

      body: ListView(
        padding: EdgeInsets.all(
          Responsive.w(context, 16 / 390),
        ),

        children: [

          // ================= DATA PROTECTED =================

          _infoCard(
            context: context,
            icon: Icons.lock_outline,
            title: "Your Data is Protected",
            description:
                "TraceIt is designed to keep your personal information secure and private.",
            color: primaryBlue,
          ),

          SizedBox(
            height: Responsive.h(context, 16 / 844),
          ),

          // ================= PERSONAL INFORMATION =================

          _infoCard(
            context: context,
            icon: Icons.person_outline,
            title: "Personal Information",
            description:
                "Your name and email are used only to identify your account and provide app features.",
            color: primaryBlue,
          ),

          SizedBox(
            height: Responsive.h(context, 16 / 844),
          ),

          // ================= LOCATION DATA =================

          _infoCard(
            context: context,
            icon: Icons.location_on_outlined,
            title: "Location Data",
            description:
                "Location information may be used for tracking your device when the required permission is enabled.",
            color: primaryBlue,
          ),

          SizedBox(
            height: Responsive.h(context, 16 / 844),
          ),

          // ================= BLUETOOTH DATA =================

          _infoCard(
            context: context,
            icon: Icons.bluetooth_outlined,
            title: "Bluetooth Data",
            description:
                "Bluetooth is used to communicate with your TraceIt device and support nearby tracking.",
            color: primaryBlue,
          ),

          SizedBox(
            height: Responsive.h(context, 16 / 844),
          ),

          // ================= DATA CONTROL =================

          _infoCard(
            context: context,
            icon: Icons.delete_outline,
            title: "Data Control",
            description:
                "You can manage app permissions and control access to your information through the app settings.",
            color: primaryBlue,
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // INFO CARD
  // ==============================================================

  static Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final Color titleColor = isDark
        ? Colors.white
        : const Color(0xFF222222);

    final Color descriptionColor = isDark
        ? Colors.white70
        : Colors.black54;

    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        Responsive.w(context, 18 / 390),
      ),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),

        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.06),
              blurRadius: Responsive.w(context, 12 / 390),
              offset: Offset(
                0,
                Responsive.h(context, 4 / 844),
              ),
            ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // ================= ICON =================

          Icon(
            icon,
            color: color,
            size: Responsive.font(context, 7.18),
          ),

          SizedBox(
            width: Responsive.w(context, 14 / 390),
          ),

          // ================= TEXT =================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: Responsive.font(context, 4.1),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 6 / 844),
                ),

                Text(
                  description,
                  style: TextStyle(
                    color: descriptionColor,
                    fontSize: Responsive.font(context, 3.33),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}