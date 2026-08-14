import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';

const Color _blue = Color(0xFF2563EB);
const Color _lightBlue = Color(0xFFEAF2FF);
const Color _textDark = Color(0xFF17233B);
const Color _textGrey = Color(0xFF667085);

class LocateScreen extends StatefulWidget {
  final DeviceModel device;

  const LocateScreen({
    super.key,
    required this.device,
  });

  @override
  State<LocateScreen> createState() => _LocateScreenState();
}

class _LocateScreenState extends State<LocateScreen> {
  bool bleAvailable = true;

  late double rssi;
  late String proximityStatus;

  String gpsStatus = "Location unavailable";

  @override
  void initState() {
    super.initState();

    rssi = widget.device.rssi.toDouble();
    proximityStatus = _getProximityStatus(rssi);
  }

  String _getProximityStatus(double rssi) {
    if (rssi >= -55) {
      return "Very Close";
    } else if (rssi >= -70) {
      return "Close";
    } else if (rssi >= -85) {
      return "Far";
    } else {
      return "Out of Range";
    }
  }

  String get locationMode {
    return bleAvailable ? "BLE Proximity" : "GPS / GSM";
  }

  @override
  Widget build(BuildContext context) {
    final deviceName = widget.device.name;
    final imagePath = widget.device.imagePath;
    final connected = widget.device.connected;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF3FF),
              Color(0xFFF7FAFF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 0.055),
              vertical: Responsive.h(context, 0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: _textDark,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 0.04),
                    ),

                    Expanded(
                      child: Text(
                        "Locate Device",
                        style: TextStyle(
                          fontSize: Responsive.font(context, 5.8),
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.more_vert_rounded,
                      color: _textDark,
                    ),
                  ],
                ),

                SizedBox(
                  height: Responsive.h(context, 0.02),
                ),

                // MAP
                _buildMapPreview(context),

                SizedBox(
                  height: Responsive.h(context, 0.018),
                ),

                // RSSI / PROXIMITY
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    Responsive.w(context, 0.04),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE6ECF5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: Responsive.w(context, 0.11),
                                height: Responsive.w(context, 0.11),
                                decoration: BoxDecoration(
                                  color: _lightBlue,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.bluetooth_rounded,
                                  color: _blue,
                                ),
                              ),

                              SizedBox(
                                width: Responsive.w(context, 0.03),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "BLE Signal",
                                    style: TextStyle(
                                      color: _textGrey,
                                      fontSize: Responsive.font(context, 3.1),
                                    ),
                                  ),

                                  SizedBox(
                                    height: Responsive.h(context, 0.003),
                                  ),

                                  Text(
                                    proximityStatus,
                                    style: TextStyle(
                                      color: _textDark,
                                      fontSize: Responsive.font(context, 4.1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Text(
                            "${rssi.toInt()} dBm",
                            style: TextStyle(
                              color: _blue,
                              fontSize: Responsive.font(context, 4.0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.018),
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: ((rssi + 100) / 70).clamp(0.0, 1.0),
                          minHeight: 7,
                          backgroundColor: const Color(0xFFE8EDF5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            _blue,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.012),
                      ),

                      Text(
                        bleAvailable
                            ? "Bluetooth proximity is active"
                            : "BLE unavailable • Using GPS / GSM",
                        style: TextStyle(
                          color: _textGrey,
                          fontSize: Responsive.font(context, 3.0),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.025),
                ),

                // REFRESH BUTTON
                SizedBox(
                  width: double.infinity,
                  height: Responsive.h(context, 0.065),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        rssi = widget.device.rssi.toDouble();
                        proximityStatus =
                            _getProximityStatus(rssi);
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(
                      "Refresh Location",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusPill(
    BuildContext context,
    bool connected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.04),
        vertical: Responsive.h(context, 0.009),
      ),
      decoration: BoxDecoration(
        color: connected
            ? const Color(0xFFE4F7EA)
            : const Color(0xFFFEECEC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Responsive.w(context, 0.018),
            height: Responsive.w(context, 0.018),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: connected
                  ? const Color(0xFF2DB55D)
                  : Colors.red,
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.02),
          ),

          Text(
            connected ? "Connected" : "Disconnected",
            style: TextStyle(
              color: connected
                  ? const Color(0xFF239447)
                  : Colors.red,
              fontSize: Responsive.font(context, 3.4),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.04),
        vertical: Responsive.h(context, 0.018),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6ECF5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: Responsive.w(context, 0.105),
            height: Responsive.w(context, 0.105),
            decoration: BoxDecoration(
              color: _lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: Responsive.w(context, 0.055),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.035),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: Responsive.font(context, 3.2),
                  ),
                ),
                SizedBox(
                  height: Responsive.h(context, 0.004),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _textDark,
                    fontSize: Responsive.font(context, 4.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Responsive.h(context, 0.34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFEAF2FF),
        border: Border.all(
          color: const Color(0xFFD5E4FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MapGridPainter(),
            ),
          ),

          Center(
            child: Container(
              width: Responsive.w(context, 0.18),
              height: Responsive.w(context, 0.18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _blue.withValues(alpha: 0.12),
              ),
              child: Center(
                child: Container(
                  width: Responsive.w(context, 0.075),
                  height: Responsive.w(context, 0.075),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _blue,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 16,
            left: 16,
            child: _mapLabel(
              context,
              "Live location",
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapLabel(
    BuildContext context,
    String text,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.03),
        vertical: Responsive.h(context, 0.009),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _textDark,
          fontSize: Responsive.font(context, 3.2),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5E4FF)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
