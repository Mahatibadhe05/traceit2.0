import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';

class StatsChips extends StatelessWidget {
  final int deviceCount;
  final int connectedCount;

  const StatsChips({
    super.key,
    required this.deviceCount,
    required this.connectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _statsCard(
            context: context,
            title: "Device${deviceCount == 1 ? '' : 's'}",
            value: "$deviceCount",
            icon: Icons.devices,
            iconColor: Colors.blue,
            isDark: isDark,
          ),
        ),

        SizedBox(
          width: Responsive.w(context, 0.025),
        ),

        Expanded(
          child: _statsCard(
            context: context,
            title: "Connected",
            value: "$connectedCount",
            icon: Icons.bluetooth_connected,
            iconColor: Colors.green,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _statsCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    return Container(
      height: Responsive.h(context, 0.12),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.035),
        vertical: Responsive.h(context, 0.018),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),
        border: Border.all(
          color: isDark
              ? const Color(0xFF303030)
              : const Color(0xFFE4EAF4),
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.w(context, 0.12),
            height: Responsive.w(context, 0.12),
            decoration: BoxDecoration(
              color: isDark
                  ? iconColor.withOpacity(0.15)
                  : iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: Responsive.font(context, 6),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.025),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF111827),
                    fontSize: Responsive.font(context, 5.5),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.004),
                ),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF667085),
                    fontSize: Responsive.font(context, 3.2),
                    fontWeight: FontWeight.w500,
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