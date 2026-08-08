import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../core/widgets/primary_button.dart';

class RingScreen extends StatelessWidget {
  final DeviceModel device;

  const RingScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(context, 0.08)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active,
                  size: Responsive.w(context, 0.25),
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: Responsive.h(context, 0.05)),
              Text(
                "Ringing ${device.name}...",
                style: AppTextStyles.heading(context),
              ),
              SizedBox(height: Responsive.h(context, 0.08)),
              SizedBox(
                width: Responsive.w(context, 0.6),
                child: PrimaryButton(
                  text: "Stop Ringing",
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
