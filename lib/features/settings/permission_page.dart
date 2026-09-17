import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/responsive.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage>
    with WidgetsBindingObserver {
  bool notificationsEnabled = false;
  bool cameraEnabled = false;
  bool microphoneEnabled = false;
  bool locationEnabled = false;

  final Color primaryBlue = const Color(0xFF1769FF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _loadPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // ==============================================================
  // REFRESH PERMISSIONS WHEN RETURNING FROM ANDROID SETTINGS
  // ==============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      _loadPermissionStatus();
    }
  }

  // ==============================================================
  // LOAD CURRENT ANDROID PERMISSION STATUS
  // ==============================================================

  Future<void> _loadPermissionStatus() async {
    try {
      final notificationStatus =
          await Permission.notification.status;

      final cameraStatus =
          await Permission.camera.status;

      final microphoneStatus =
          await Permission.microphone.status;

      final locationStatus =
          await Permission.locationWhenInUse.status;

      if (!mounted) return;

      setState(() {
        notificationsEnabled =
            notificationStatus.isGranted;

        cameraEnabled =
            cameraStatus.isGranted;

        microphoneEnabled =
            microphoneStatus.isGranted;

        locationEnabled =
            locationStatus.isGranted;
      });
    } catch (e) {
      debugPrint(
        'Permission status error: $e',
      );
    }
  }

  // ==============================================================
  // HANDLE PERMISSION SWITCH
  // ==============================================================

  Future<void> _handlePermission(
    Permission permission,
    bool newValue,
    String permissionName,
  ) async {
    // ============================================================
    // USER IS TRYING TO ENABLE THE PERMISSION
    // ============================================================

    if (newValue) {
      final status = await permission.request();

      if (!mounted) return;

      // Permission successfully granted
      if (status.isGranted) {
        await _loadPermissionStatus();
        return;
      }

      // Permission permanently denied
      if (status.isPermanentlyDenied) {
        await _showSettingsDialog(
          permissionName,
        );
        return;
      }

      // Permission denied but may be requested again
      await _loadPermissionStatus();

      return;
    }

    // ============================================================
    // USER IS TRYING TO DISABLE THE PERMISSION
    // ============================================================

    await _showDisableDialog(
      permissionName,
    );
  }

  // ==============================================================
  // OPEN ANDROID APP SETTINGS
  // ==============================================================

  Future<void> _openAppSettings() async {
    await openAppSettings();

    // The lifecycle callback will refresh
    // the permission status when the user
    // returns to TraceIt.
  }

  // ==============================================================
  // PERMISSION PERMANENTLY DENIED DIALOG
  // ==============================================================

  Future<void> _showSettingsDialog(
    String permissionName,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            '$permissionName permission',
          ),
          content: Text(
            '$permissionName permission has been denied. '
            'Please enable it from the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _openAppSettings();
              },
              child: const Text(
                'Open Settings',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // DISABLE PERMISSION DIALOG
  // ==============================================================

  Future<void> _showDisableDialog(
    String permissionName,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Manage $permissionName',
          ),
          content: Text(
            'Android does not allow TraceIt to directly '
            'turn $permissionName off.\n\n'
            'You can disable it from the Android app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _openAppSettings();
              },
              child: const Text(
                'Open Settings',
              ),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final Color backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F9FF);

    final Color appBarColor = isDark
        ? const Color(0xFF121212)
        : Colors.white;

    final Color primaryTextColor = isDark
        ? Colors.white
        : const Color(0xFF18264A);

    final Color informationBoxColor = isDark
        ? const Color(0xFF1D3157)
        : const Color(0xFFEAF1FF);

    final Color informationTextColor = isDark
        ? const Color(0xFFB8C7E6)
        : const Color(0xFF4B5B7A);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryTextColor,
            size: Responsive.font(
              context,
              6,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Permission Management',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: Responsive.font(
              context,
              5.13,
            ),
          ),
        ),
      ),

      // ================= BODY =================

      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          Responsive.w(
            context,
            16 / 390,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ================= HEADING =================

            Text(
              'Manage Permissions',
              style: TextStyle(
                color: primaryBlue,
                fontSize: Responsive.font(
                  context,
                  4.62,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: Responsive.h(
                context,
                6 / 844,
              ),
            ),

            Text(
              'Control which permissions TraceIt can use.',
              style: TextStyle(
                color: isDark
                    ? Colors.grey.shade400
                    : Colors.grey,
                fontSize: Responsive.font(
                  context,
                  3.59,
                ),
              ),
            ),

            SizedBox(
              height: Responsive.h(
                context,
                20 / 844,
              ),
            ),

            // ================= NOTIFICATIONS =================

            _permissionCard(
              context: context,
              icon: Icons.notifications_none,
              title: 'Notifications',
              description:
                  'Allow TraceIt to send alerts and updates.',
              value: notificationsEnabled,
              onChanged: (value) {
                _handlePermission(
                  Permission.notification,
                  value,
                  'Notifications',
                );
              },
            ),

            SizedBox(
              height: Responsive.h(
                context,
                14 / 844,
              ),
            ),

            // ================= CAMERA =================

            _permissionCard(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: 'Camera',
              description:
                  'Used when scanning or setting up your device.',
              value: cameraEnabled,
              onChanged: (value) {
                _handlePermission(
                  Permission.camera,
                  value,
                  'Camera',
                );
              },
            ),

            SizedBox(
              height: Responsive.h(
                context,
                14 / 844,
              ),
            ),

            // ================= MICROPHONE =================

            _permissionCard(
              context: context,
              icon: Icons.mic_none,
              title: 'Microphone',
              description:
                  'Used for voice-based device commands.',
              value: microphoneEnabled,
              onChanged: (value) {
                _handlePermission(
                  Permission.microphone,
                  value,
                  'Microphone',
                );
              },
            ),

            SizedBox(
              height: Responsive.h(
                context,
                14 / 844,
              ),
            ),

            // ================= LOCATION =================

            _permissionCard(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Location',
              description:
                  'Used to track your device and show its location.',
              value: locationEnabled,
              onChanged: (value) {
                _handlePermission(
                  Permission.locationWhenInUse,
                  value,
                  'Location',
                );
              },
            ),

            SizedBox(
              height: Responsive.h(
                context,
                22 / 844,
              ),
            ),

            // ================= INFORMATION BOX =================

            Container(
              width: double.infinity,

              padding: EdgeInsets.all(
                Responsive.w(
                  context,
                  16 / 390,
                ),
              ),

              decoration: BoxDecoration(
                color: informationBoxColor,

                borderRadius:
                    BorderRadius.circular(
                  Responsive.radius(
                    context,
                    16,
                  ),
                ),
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.info_outline,
                    color: primaryBlue,
                    size: Responsive.font(
                      context,
                      5.64,
                    ),
                  ),

                  SizedBox(
                    width: Responsive.w(
                      context,
                      10 / 390,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'You can change these permissions at any time. '
                      'Some features may not work if the required '
                      'permission is disabled.',
                      style: TextStyle(
                        color: informationTextColor,
                        fontSize:
                            Responsive.font(
                          context,
                          3.33,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Responsive.h(
                context,
                20 / 844,
              ),
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
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : Colors.white;

    final Color titleColor = isDark
        ? Colors.white
        : const Color(0xFF222222);

    final Color descriptionColor = isDark
        ? Colors.grey.shade400
        : Colors.grey;

    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(
          context,
          16 / 390,
        ),
        vertical: Responsive.h(
          context,
          16 / 844,
        ),
      ),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          Responsive.radius(
            context,
            18,
          ),
        ),
      ),

      child: Row(
        children: [

          // ================= SHIELD ICON =================

          SizedBox(
            width: Responsive.w(
              context,
              32 / 390,
            ),

            child: Align(
              alignment: Alignment.topCenter,

              child: Icon(
                Icons.shield_outlined,
                color: primaryBlue,
                size: Responsive.font(
                  context,
                  5.64,
                ),
              ),
            ),
          ),

          SizedBox(
            width: Responsive.w(
              context,
              8 / 390,
            ),
          ),

          // ================= MAIN PERMISSION ICON =================

          Icon(
            icon,
            color: primaryBlue,
            size: Responsive.font(
              context,
              5.64,
            ),
          ),

          SizedBox(
            width: Responsive.w(
              context,
              14 / 390,
            ),
          ),

          // ================= TEXT =================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      4.1,
                    ),
                    fontWeight:
                        FontWeight.w600,
                    color: titleColor,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(
                    context,
                    5 / 844,
                  ),
                ),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: Responsive.font(
                      context,
                      3.2,
                    ),
                    color: descriptionColor,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: Responsive.w(
              context,
              6 / 390,
            ),
          ),

          // ================= SWITCH =================

          Switch(
            value: value,
            onChanged: onChanged,

            activeThumbColor:
                primaryBlue,

            activeTrackColor:
                const Color(0xFF8DB5FF),
          ),
        ],
      ),
    );
  }
}