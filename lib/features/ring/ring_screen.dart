import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';

const Color _blue = Color(0xFF2563EB);
const Color _textDark = Color(0xFF17233B);
const Color _textGrey = Color(0xFF667085);
const Color _softBlue = Color(0xFFF4F8FF);

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
  late AnimationController _animationController;

  void _stopRinging() {
    _animationController.stop();
  }

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
      backgroundColor: const Color(0xFFFCFDFF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.w(context, 0.04),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _textDark,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  SizedBox(
                    width: Responsive.w(context, 0.035),
                  ),

                  Text(
                    "Ring Device",
                    style: TextStyle(
                      color: _textDark,
                      fontSize: Responsive.font(context, 5.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 0.055),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // RINGING STATE
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final scale = 1.0 + (_animationController.value * 0.12);
                          
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: Responsive.w(context, 0.30),
                              height: Responsive.w(context, 0.30),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _softBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: _blue.withValues(alpha: 0.08),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.notifications_active_rounded,
                                color: _blue,
                                size: Responsive.w(context, 0.15),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(
                        height: Responsive.h(context, 0.035),
                      ),

                      Text(
                        "Ringing ${widget.device.name}...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textDark,
                          fontSize: Responsive.font(context, 5.2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.012),
                      ),

                      Text(
                        "Playing sound on your device",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textGrey,
                          fontSize: Responsive.font(context, 3.4),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.045),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: Responsive.h(context, 0.065),
                        child: ElevatedButton(
                          onPressed: () {
                            _stopRinging();
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Stop Ringing",
                            style: TextStyle(
                              fontSize: Responsive.font(context, 3.7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
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

