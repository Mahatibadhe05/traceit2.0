import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';

class BleScanScreen extends StatelessWidget {
  const BleScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Scan Devices",
          style: AppTextStyles.heading(context).copyWith(
            fontSize: Responsive.font(context, 6),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 5),
        ),
        child: Center(
          child: Text(
            "BLE Scan Screen",
            style: AppTextStyles.heading(context).copyWith(
              fontSize: Responsive.font(context, 5),
            ),
          ),
        ),
      ),
    );
  }
}