import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../core/widgets/primary_button.dart';

class RingScreen extends StatefulWidget {
  final DeviceModel device;

  const RingScreen({
    super.key,
    required this.device,
  });

  @override
  State<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends State<RingScreen>
    with SingleTickerProviderStateMixin {
  bool isRinging = true;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scale = isRinging
                        ? 1.0 + (_animationController.value * 0.12)
                        : 1.0;
                
                    return Transform.scale(
                      scale: scale,
                      child: Icon(
                        isRinging
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                        size: Responsive.w(context, 0.25),
                        color: isRinging ? Colors.blue : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Responsive.h(context, 0.05)),
              Text(
                isRinging
                    ? "Ringing ${widget.device.name}..."
                    : "Ring stopped",
                style: AppTextStyles.heading(context),
              ),
              SizedBox(height: Responsive.h(context, 0.08)),
              SizedBox(
                width: Responsive.w(context, 0.6),
                child: PrimaryButton(
                  text: isRinging ? "Stop Ringing" : "Close",
                  onPressed: () {
                    if (isRinging) {
                      setState(() {
                        isRinging = false;
                      });
                    
                      _animationController.stop();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
