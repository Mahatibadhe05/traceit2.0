import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color darkBlue = Color(0xFF14244A);

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8FAFF);

    final Color appBarColor = isDark
        ? const Color(0xFF121212)
        : Colors.white;

    final Color textColor = isDark
        ? Colors.white
        : darkBlue;

    final Color secondaryTextColor = isDark
        ? Colors.white70
        : Colors.black54;

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final Color iconBackgroundColor = isDark
        ? const Color(0xFF263B66)
        : const Color(0xFFE4EDFF);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
            size: Responsive.font(context, 6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "About TraceIt",
          style: TextStyle(
            color: textColor,
            fontSize: Responsive.font(context, 5.65),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================

      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 20 / 390),
          vertical: Responsive.h(context, 20 / 844),
        ),

        children: [

          // ================= APP LOGO =================

          Center(
            child: Container(
              width: Responsive.w(context, 90 / 390),
              height: Responsive.h(context, 90 / 844),

              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 24),
                ),
              ),

              child: Icon(
                Icons.location_searching,
                size: Responsive.font(context, 12.3),
                color: primaryBlue,
              ),
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 18 / 844),
          ),

          // ================= APP NAME =================

          Center(
            child: Text(
              "TraceIt",
              style: TextStyle(
                color: textColor,
                fontSize: Responsive.font(context, 7.18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 6 / 844),
          ),

          // ================= TAGLINE =================

          Center(
            child: Text(
              "Never lose what matters.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.font(context, 3.59),
              ),
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 30 / 844),
          ),

          // ================= ABOUT =================

          _infoCard(
            context: context,
            icon: Icons.info_outline,
            title: "About TraceIt",
            text:
                "TraceIt is a smart item-finding system designed to help you locate and keep track of important belongings such as keys, bags, wallets and other everyday items.",
            cardColor: cardColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            iconBackgroundColor: iconBackgroundColor,
          ),

          SizedBox(
            height: Responsive.h(context, 14 / 844),
          ),

          // ================= FEATURES =================

          _infoCard(
            context: context,
            icon: Icons.auto_awesome_outlined,
            title: "What TraceIt Does",
            text:
                "TraceIt connects your smart finder device with the mobile application to help you locate your belongings quickly using alerts, sound, vibration and location-based features.",
            cardColor: cardColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            iconBackgroundColor: iconBackgroundColor,
          ),

          SizedBox(
            height: Responsive.h(context, 14 / 844),
          ),

          // ================= TECHNOLOGY =================

          _infoCard(
            context: context,
            icon: Icons.memory_outlined,
            title: "Technology",
            text:
                "TraceIt is built using modern mobile and embedded technologies, combining a smart hardware device with a Flutter-based mobile application.",
            cardColor: cardColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            iconBackgroundColor: iconBackgroundColor,
          ),

          SizedBox(
            height: Responsive.h(context, 14 / 844),
          ),

          // ================= VERSION =================

          Container(
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
                    blurRadius:
                        Responsive.w(context, 12 / 390),
                    offset: Offset(
                      0,
                      Responsive.h(context, 4 / 844),
                    ),
                  ),
              ],
            ),

            child: Row(
              children: [

                // VERSION ICON

                Icon(
                  Icons.system_update_outlined,
                  color: primaryBlue,
                  size: Responsive.font(context, 6.92),
                ),

                SizedBox(
                  width: Responsive.w(context, 15 / 390),
                ),

                // VERSION TEXT

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "App Version",
                        style: TextStyle(
                          color: textColor,
                          fontSize:
                              Responsive.font(context, 4.1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(
                        height:
                            Responsive.h(context, 4 / 844),
                      ),

                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize:
                              Responsive.font(context, 3.59),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 30 / 844),
          ),

          // ================= FOOTER =================

          Center(
            child: Text(
              "TraceIt",
              style: TextStyle(
                color: primaryBlue,
                fontSize: Responsive.font(context, 3.59),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 4 / 844),
          ),

          Center(
            child: Text(
              "Smart tracking. Simple living.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.font(context, 3.08),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO CARD =================

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String text,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
  }) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
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
              blurRadius:
                  Responsive.w(context, 12 / 390),
              offset: Offset(
                0,
                Responsive.h(context, 4 / 844),
              ),
            ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ================= CARD ICON =================

          Container(
            width: Responsive.w(context, 46 / 390),
            height: Responsive.h(context, 46 / 844),

            decoration: BoxDecoration(
              color: iconBackgroundColor,

              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 14),
              ),
            ),

            child: Icon(
              icon,
              color: primaryBlue,
              size: Responsive.font(context, 6.15),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 15 / 390),
          ),

          // ================= CARD CONTENT =================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize:
                        Responsive.font(context, 4.1),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(
                  height:
                      Responsive.h(context, 7 / 844),
                ),

                Text(
                  text,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize:
                        Responsive.font(context, 3.33),
                    height: 1.45,
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