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
              style: AppTextStyles.heading(context),
            ),
            SizedBox(height: Responsive.h(context, 0.005)),
            Text(
              hasDevice
                  ? "Track and protect what matters."
                  : "Never lose what matters.",
              style: AppTextStyles.subtitle(context),
            ),
          ],
        ),

        if (hasDevice)
          GestureDetector(
            onTap: onAddDevice,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
