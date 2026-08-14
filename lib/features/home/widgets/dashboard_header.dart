import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';

class DashboardHeader extends StatelessWidget {
  final bool hasDevice;
  final VoidCallback onAddDevice;

  const DashboardHeader({
    super.key,
    required this.hasDevice,
    required this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasDevice ? "My Devices" : "Welcome to TraceIt",
              maxLines: 1,
              style: AppTextStyles.heading(context).copyWith(
                fontSize: Responsive.font(context, 6.2),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF17233B),
              ),
            ),
            SizedBox(height: Responsive.h(context, 0.008)),
            Text(
              hasDevice
                  ? "Track and protect what matters."
                  : "Never lose what matters.",
              style: AppTextStyles.subtitle(context).copyWith(
                fontSize: Responsive.font(context, 3.3),
                color: const Color(0xFF667085),
              ),
            ),
          ],
        ),

        if (hasDevice)
          GestureDetector(
            onTap: onAddDevice,
            child: Container(
              width: Responsive.w(context, 0.095),
              height: Responsive.w(context, 0.095),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.22),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: Responsive.w(context, 0.055),
              ),
            ),
          ),
      ],
    );
  }
}
