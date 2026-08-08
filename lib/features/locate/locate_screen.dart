import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../core/widgets/primary_button.dart';

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
  bool isRefreshing = false;
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

  void _simulateBleLoss() {
    setState(() {
      bleAvailable = !bleAvailable;

      if (!bleAvailable) {
        gpsStatus = "GPS/GSM location available";
      } else {
        rssi = widget.device.rssi.toDouble();
        proximityStatus = _getProximityStatus(rssi);
      }
    });
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

  String get _locationMode {
    return bleAvailable ? "BLE Proximity" : "GPS / GSM";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.device.name, style: AppTextStyles.heading(context)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(Responsive.w(context, 0.04)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(Responsive.radius(context, 20)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Responsive.w(context, 0.28),
                          height: Responsive.w(context, 0.28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade50,
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: Responsive.w(context, 0.13),
                            color: Colors.blue,
                          ),
                        ),
                
                        SizedBox(
                          height: Responsive.h(context, 0.018),
                        ),
                
                        Text(
                          bleAvailable ? proximityStatus : "BLE Out of Range",
                          style: TextStyle(
                            fontSize: Responsive.font(context, 0.042),
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                
                        SizedBox(
                          height: Responsive.h(context, 0.008),
                        ),
                
                        Text(
                          bleAvailable
                              ? "RSSI: ${rssi.toStringAsFixed(0)} dBm"
                              : gpsStatus,
                          style: AppTextStyles.subtitle(context),
                        ),

                        SizedBox(
                          height: Responsive.h(context, 0.005),
                        ),

                        Text(
                          _locationMode,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: Responsive.font(context, 0.035),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(Responsive.w(context, 0.06)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.radius(context, 30))),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(context, Icons.battery_full, "Battery", "${widget.device.battery}%", Colors.green),
                        _buildStat(context, Icons.network_wifi, "Signal", widget.device.signal, Colors.blue),
                        _buildStat(
                          context,
                          bleAvailable ? Icons.bluetooth : Icons.gps_fixed,
                          bleAvailable ? "Proximity" : "Location",
                          bleAvailable ? proximityStatus : "GPS/GSM",
                          bleAvailable ? Colors.blue : Colors.green,
                        ),
                        _buildStat(context, Icons.access_time, "Last Seen", widget.device.lastSeen, Colors.purple),
                      ],
                    ),
                    SizedBox(height: Responsive.h(context, 0.05)),
                    PrimaryButton(
                      text: isRefreshing
                          ? "Updating..."
                          : "Refresh Location",
                      onPressed: isRefreshing
                          ? null
                          : () {
                              setState(() {
                                isRefreshing = true;
                              });
                    
                              Future.delayed(
                                const Duration(seconds: 1),
                              ).then((_) {
                                if (!mounted) return;
                    
                                setState(() {
                                  // Temporary RSSI simulation.
                                  // Later this will come from the real BLE scanner.
                                  rssi = widget.device.rssi.toDouble();
                                  proximityStatus = _getProximityStatus(rssi);
                    
                                  isRefreshing = false;
                                });
                              });
                            },
                    ),
                    SizedBox(
                      height: Responsive.h(context, 0.02),
                    ),
                    OutlinedButton.icon(
                      onPressed: _simulateBleLoss,
                      icon: Icon(
                        bleAvailable ? Icons.bluetooth_disabled : Icons.bluetooth,
                      ),
                      label: Text(
                        bleAvailable
                            ? "Simulate BLE Out of Range"
                            : "Simulate BLE Back in Range",
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 0.02)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: Responsive.w(context, 0.06),
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: Responsive.h(context, 0.01)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 0.035))),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: Responsive.font(context, 0.03))),
      ],
    );
  }
}
