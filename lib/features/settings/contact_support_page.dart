import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

const Color primaryBlue = Color(0xFF1769FF);
const Color darkBlue = Color(0xFF14244A);

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: darkBlue,
            size: Responsive.font(context, 6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Contact Support",
          style: TextStyle(
            color: darkBlue,
            fontSize: Responsive.font(context, 5.65),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================= BODY =================

      body: ListView(
        padding: EdgeInsets.fromLTRB(
          Responsive.w(context, 16 / 390),
          Responsive.h(context, 20 / 844),
          Responsive.w(context, 16 / 390),
          Responsive.h(context, 30 / 844),
        ),

        children: [

          // ================= HEADER =================

          Container(
            padding: EdgeInsets.all(
              Responsive.w(context, 20 / 390),
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 18),
              ),

              boxShadow: [
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

            child: Column(
              children: [

                // SUPPORT ICON

                CircleAvatar(
                  radius: Responsive.radius(context, 30),
                  backgroundColor: const Color(0xFFE4EDFF),

                  child: Icon(
                    Icons.support_agent,
                    color: primaryBlue,
                    size: Responsive.font(context, 8.72),
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 14 / 844),
                ),

                // HEADER TITLE

                Text(
                  "We're here to help",
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: Responsive.font(context, 5.13),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 7 / 844),
                ),

                // HEADER DESCRIPTION

                Text(
                  "Having trouble with TraceIt? "
                  "Choose an option below and we'll help you out.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: Responsive.font(context, 3.59),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 24 / 844),
          ),

          // ================= EMAIL SUPPORT =================

          _supportCard(
            context: context,
            icon: Icons.email_outlined,
            title: "Email Support",
            subtitle: "Get help from the TraceIt support team",
            onTap: () {
              _showMessage(
                context,
                "Email support will be connected soon.",
              );
            },
          ),

          SizedBox(
            height: Responsive.h(context, 12 / 844),
          ),

          // ================= REPORT PROBLEM =================

          _supportCard(
            context: context,
            icon: Icons.bug_report_outlined,
            title: "Report a Problem",
            subtitle: "Tell us if something isn't working correctly",
            onTap: () {
              _showMessage(
                context,
                "Problem reporting will be available soon.",
              );
            },
          ),

          SizedBox(
            height: Responsive.h(context, 12 / 844),
          ),

          // ================= FEEDBACK =================

          _supportCard(
            context: context,
            icon: Icons.feedback_outlined,
            title: "Send Feedback",
            subtitle: "Share your suggestions with us",
            onTap: () {
              _showMessage(
                context,
                "Feedback option will be available soon.",
              );
            },
          ),

          SizedBox(
            height: Responsive.h(context, 24 / 844),
          ),

          // ================= SUPPORT INFORMATION TITLE =================

          Text(
            "SUPPORT INFORMATION",
            style: TextStyle(
              color: primaryBlue,
              fontSize: Responsive.font(context, 3.59),
              fontWeight: FontWeight.bold,
              letterSpacing: Responsive.w(context, 0.5 / 390),
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 10 / 844),
          ),

          // ================= SUPPORT INFO CARD =================

          Container(
            padding: EdgeInsets.all(
              Responsive.w(context, 18 / 390),
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 18),
              ),

              boxShadow: [
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

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= SUPPORT HOURS =================

                Row(
                  children: [

                    Icon(
                      Icons.access_time_outlined,
                      color: primaryBlue,
                      size: Responsive.font(context, 5.64),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 12 / 390),
                    ),

                    Text(
                      "Support Hours",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: Responsive.font(context, 3.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: Responsive.h(context, 8 / 844),
                ),

                Text(
                  "Monday – Friday\n9:00 AM – 6:00 PM",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: Responsive.font(context, 3.33),
                    height: 1.5,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 18 / 844),
                ),

                // ================= RESPONSE TIME =================

                Row(
                  children: [

                    Icon(
                      Icons.info_outline,
                      color: primaryBlue,
                      size: Responsive.font(context, 5.64),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 12 / 390),
                    ),

                    Text(
                      "Response Time",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: Responsive.font(context, 3.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: Responsive.h(context, 8 / 844),
                ),

                Text(
                  "We aim to respond to support requests "
                  "within 1–2 working days.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: Responsive.font(context, 3.33),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: Responsive.h(context, 28 / 844),
          ),

          // ================= FOOTER =================

          Center(
            child: Text(
              "TraceIt • Never lose what matters.",
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

  // ================= SUPPORT CARD =================

  static Widget _supportCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),

        boxShadow: [
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

      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 18 / 390),
          vertical: Responsive.h(context, 8 / 844),
        ),

        // ================= LEADING ICON =================

        leading: Container(
          padding: EdgeInsets.all(
            Responsive.w(context, 10 / 390),
          ),

          decoration: BoxDecoration(
            color: const Color(0xFFE4EDFF),
            borderRadius: BorderRadius.circular(
              Responsive.radius(context, 12),
            ),
          ),

          child: Icon(
            icon,
            color: primaryBlue,
            size: Responsive.font(context, 6.41),
          ),
        ),

        // ================= TITLE =================

        title: Text(
          title,
          style: TextStyle(
            color: darkBlue,
            fontSize: Responsive.font(context, 4.1),
            fontWeight: FontWeight.w600,
          ),
        ),

        // ================= SUBTITLE =================

        subtitle: Padding(
          padding: EdgeInsets.only(
            top: Responsive.h(context, 4 / 844),
          ),

          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.black54,
              fontSize: Responsive.font(context, 3.33),
            ),
          ),
        ),

        // ================= ARROW =================

        trailing: Icon(
          Icons.chevron_right,
          color: primaryBlue,
          size: Responsive.font(context, 6),
        ),

        onTap: onTap,
      ),
    );
  }

  // ================= MESSAGE =================

  static void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}