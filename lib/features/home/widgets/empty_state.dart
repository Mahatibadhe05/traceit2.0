import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/primary_button.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddDevice;

  const EmptyState({
    super.key,
    required this.onAddDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bluetooth_searching_rounded,
          size: Responsive.w(context, 0.12),
          color: AppColors.primary,
        ),
        SizedBox(height: Responsive.h(context, 0.05)),
        Text(
          "No devices added yet",
          style: AppTextStyles.heading(context).copyWith(
            fontSize: Responsive.font(context, 3.8),
          ),
        ),
        SizedBox(height: Responsive.h(context, 0.015)),
        Text(
          "Start by adding your first smart tracker.",
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle(context),
        ),
        SizedBox(height: Responsive.h(context, 0.04)),
        SizedBox(
          width: Responsive.w(context, 0.60),
          child: PrimaryButton(
            text: "Add Your First Device",
            onPressed: onAddDevice,
          ),
        ),
      ],
    );
  }
}
