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

    final horizontalPadding =
        width < 600 ? 22.0 : 40.0;

    final iconSize =
        width < 600 ? 90.0 : 120.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF263247),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Alert Details',
          style: TextStyle(
            color: Color(0xFF263247),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),

        child: Column(
          children: [
            // ==================================================
            // ALERT ICON
            // ==================================================

            Container(
              width: iconSize,
              height: iconSize,

              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(28),
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
                fontSize: width < 600 ? 26 : 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF263247),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DEVICE
            // ==================================================

            Text(
              device,
              style: TextStyle(
                fontSize: width < 600 ? 17 : 20,
                color: const Color(0xFF8495AE),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // ==================================================
            // TIME
            // ==================================================

            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9AA9BD),
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
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(20),

                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Alert Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF263247),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _InfoRow(
                    icon: Icons.devices,
                    label: 'Device',
                    value: device,
                  ),

                  const Divider(height: 28),

                  _InfoRow(
                    icon: Icons.notifications,
                    label: 'Alert',
                    value: title,
                  ),

                  const Divider(height: 28),

                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: time,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6C63FF),

                  foregroundColor:
                      Colors.white,

                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          color: const Color(0xFF6C63FF),
          size: 24,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9AA9BD),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF263247),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}