import 'package:flutter/material.dart';

class AlertDetailsScreen extends StatelessWidget {
  final String title;
  final String device;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const AlertDetailsScreen({
    super.key,
    required this.title,
    required this.device,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // ==========================================================
    // THEME COLORS
    // ==========================================================

    final pageBackground =
        isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF7F8FC);

    final surfaceColor =
        isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white;

    final primaryText =
        isDark
            ? Colors.white
            : const Color(0xFF263247);

    final secondaryText =
        isDark
            ? Colors.white70
            : const Color(0xFF8495AE);

    final tertiaryText =
        isDark
            ? Colors.white54
            : const Color(0xFF9AA9BD);

    final dividerColor =
        isDark
            ? Colors.white24
            : Colors.grey.shade300;

    final horizontalPadding =
        width < 600 ? 22.0 : 40.0;

    final iconSize =
        width < 600 ? 90.0 : 120.0;

    return Scaffold(
      backgroundColor: pageBackground,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Alert Details',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          horizontalPadding,
        ),

        child: Column(
          children: [

            // ==================================================
            // ALERT ICON
            // ==================================================

            Container(
              width: iconSize,
              height: iconSize,

              decoration: BoxDecoration(
                color: isDark
                    ? Color.alphaBlend(
                        iconColor.withOpacity(0.12),
                        const Color(0xFF1E1E1E),
                      )
                    : backgroundColor,
                borderRadius:
                    BorderRadius.circular(28),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: width < 600 ? 45 : 60,
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TITLE
            // ==================================================

            Text(
              title,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize:
                    width < 600 ? 26 : 32,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DEVICE
            // ==================================================

            Text(
              device,
              style: TextStyle(
                fontSize:
                    width < 600 ? 17 : 20,
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // ==================================================
            // TIME
            // ==================================================

            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color: tertiaryText,
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // DETAILS CARD
            // ==================================================

            Container(
              width: double.infinity,

              padding: EdgeInsets.all(
                width < 600 ? 20 : 28,
              ),

              decoration: BoxDecoration(
                color: surfaceColor,

                borderRadius:
                    BorderRadius.circular(20),

                boxShadow: isDark
                    ? []
                    : const [
                        BoxShadow(
                          color:
                              Color(0x12000000),
                          blurRadius: 12,
                          offset:
                              Offset(0, 4),
                        ),
                      ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ==================================================
                  // CARD TITLE
                  // ==================================================

                  Text(
                    'Alert Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w700,
                      color: primaryText,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // DEVICE
                  // ==================================================

                  _InfoRow(
                    icon: Icons.devices,
                    label: 'Device',
                    value: device,
                    primaryText: primaryText,
                    secondaryText: tertiaryText,
                  ),

                  Divider(
                    height: 28,
                    color: dividerColor,
                  ),

                  // ==================================================
                  // ALERT
                  // ==================================================

                  _InfoRow(
                    icon:
                        Icons.notifications,
                    label: 'Alert',
                    value: title,
                    primaryText: primaryText,
                    secondaryText: tertiaryText,
                  ),

                  Divider(
                    height: 28,
                    color: dividerColor,
                  ),

                  // ==================================================
                  // TIME
                  // ==================================================

                  _InfoRow(
                    icon:
                        Icons.access_time,
                    label: 'Time',
                    value: time,
                    primaryText: primaryText,
                    secondaryText: tertiaryText,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // BACK BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(
                  Icons.arrow_back,
                ),

                label: const Text(
                  'Back to Alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6C63FF),

                  foregroundColor:
                      Colors.white,

                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// INFORMATION ROW
// ==========================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primaryText;
  final Color secondaryText;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        // ==================================================
        // ICON
        // ==================================================

        const Icon(
          Icons.devices,
          color: Color(0xFF6C63FF),
          size: 24,
        ),

        const SizedBox(width: 14),

        // ==================================================
        // TEXT
        // ==================================================

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: secondaryText,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryText,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}