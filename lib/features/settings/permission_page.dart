import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool notificationsEnabled = true;
  bool cameraEnabled = true;
  bool microphoneEnabled = true;
  bool locationEnabled = true;

  final Color primaryBlue = const Color(0xFF1769FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FF),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: Responsive.font(context, 6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Permission Management",
          style: TextStyle(
            color: const Color(0xFF18264A),
            fontWeight: FontWeight.bold,
            fontSize: Responsive.font(context, 5.13),
          ),
        ),
      ),

      // ================= BODY =================

      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          Responsive.w(context, 16 / 390),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADING =================

            Text(
              "Manage Permissions",
              style: TextStyle(
                color: primaryBlue,
                fontSize: Responsive.font(context, 4.62),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 6 / 844),
            ),

            Text(
              "Control which permissions TraceIt can use.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: Responsive.font(context, 3.59),
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 20 / 844),
            ),

            // ================= NOTIFICATIONS =================

            _permissionCard(
              context: context,
              icon: Icons.notifications_none,
              title: "Notifications",
              description:
                  "Allow TraceIt to send alerts and updates.",
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),

            SizedBox(
              height: Responsive.h(context, 14 / 844),
            ),

            // ================= CAMERA =================

            _permissionCard(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: "Camera",
              description:
                  "Used when scanning or setting up your device.",
              value: cameraEnabled,
              onChanged: (value) {
                setState(() {
                  cameraEnabled = value;
                });
              },
            ),

            SizedBox(
              height: Responsive.h(context, 14 / 844),
            ),

            // ================= MICROPHONE =================

            _permissionCard(
              context: context,
              icon: Icons.mic_none,
              title: "Microphone",
              description:
                  "Used for voice-based device commands.",
              value: microphoneEnabled,
              onChanged: (value) {
                setState(() {
                  microphoneEnabled = value;
                });
              },
            ),

            SizedBox(
              height: Responsive.h(context, 14 / 844),
            ),

            // ================= LOCATION =================

            _permissionCard(
              context: context,
              icon: Icons.location_on_outlined,
              title: "Location",
              description:
                  "Used to track your device and show its location.",
              value: locationEnabled,
              onChanged: (value) {
                setState(() {
                  locationEnabled = value;
                });
              },
            ),

            SizedBox(
              height: Responsive.h(context, 22 / 844),
            ),

            // ================= INFORMATION BOX =================

            Container(
              width: double.infinity,

              padding: EdgeInsets.all(
                Responsive.w(context, 16 / 390),
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),

                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 16),
                ),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.info_outline,
                    color: primaryBlue,
                    size: Responsive.font(context, 5.64),
                  ),

                  SizedBox(
                    width: Responsive.w(context, 10 / 390),
                  ),

                  Expanded(
                    child: Text(
                      "You can change these permissions at any time. "
                      "Some features may not work if the required "
                      "permission is disabled.",
                      style: TextStyle(
                        color: const Color(0xFF4B5B7A),
                        fontSize: Responsive.font(context, 3.33),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 20 / 844),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // PERMISSION CARD
  // ==============================================================

  Widget _permissionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 16 / 390),
        vertical: Responsive.h(context, 16 / 844),
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),
      ),

      child: Row(
        children: [

          // ================= SHIELD ICON =================

          SizedBox(
            width: Responsive.w(context, 32 / 390),

            child: Align(
              alignment: Alignment.topCenter,

              child: Icon(
                Icons.shield_outlined,
                color: primaryBlue,
                size: Responsive.font(context, 5.64),
              ),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 8 / 390),
          ),

          // ================= MAIN PERMISSION ICON =================

          Icon(
            icon,
            color: primaryBlue,
            size: Responsive.font(context, 5.64),
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
                    fontSize: Responsive.font(context, 4.1),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF222222),
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 5 / 844),
                ),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: Responsive.font(context, 3.2),
                    color: Colors.grey,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 6 / 390),
          ),

          // ================= SWITCH =================

          Switch(
            value: value,
            onChanged: onChanged,

            activeThumbColor: primaryBlue,

            activeTrackColor: const Color(0xFF8DB5FF),
          ),
        ],
      ),
    );
  }
}