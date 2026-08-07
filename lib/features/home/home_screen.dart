import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/primary_button.dart';
import '../add_device/add_device_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 0.06),
            ),
            child: Column(
              children: [
                SizedBox(height: Responsive.h(context, 0.10)),
                Center(
  child: Text(
    "Welcome to TraceIt",
    style: AppTextStyles.heading(context),
  ),
),
                Center(
  child: Text(
    "Never lose what matters.",
    style: AppTextStyles.subtitle(context),
  ),
),
                SizedBox(height: Responsive.h(context, 0.08)),
                Icon(
  Icons.bluetooth_searching_rounded,
  size: Responsive.w(context, 0.12),
  color: AppColors.primary,
),
                SizedBox(height: Responsive.h(context, 0.05)),
                Text(
  "No devices added yet",
  style: AppTextStyles.heading(context).copyWith(
    fontSize: Responsive.font(context, 0.028),
    fontWeight: FontWeight.w600,
  ),
),
                SizedBox(height: Responsive.h(context, 0.015)),
                Text(
                  "Start by adding your first smart tracker.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(context),
                ),
                SizedBox(height: Responsive.h(context, 0.04)),
                Center(
  child: SizedBox(
    width: Responsive.w(context, 0.55),
    child: PrimaryButton(
      text: "Add Your First Device",
      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddDeviceScreen(),
    ),
  );
},
    ),
  ),
),
                SizedBox(height: Responsive.h(context, 0.04)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}