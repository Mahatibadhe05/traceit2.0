import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../core/widgets/primary_button.dart';
import '../ring/ring_screen.dart';

class LocateScreen extends StatelessWidget {
  final DeviceModel device;

  const LocateScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(device.name, style: AppTextStyles.heading(context)),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: Responsive.w(context, 0.15), color: Colors.grey.shade400),
                      SizedBox(height: Responsive.h(context, 0.02)),
                      Text("MAP", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                        _buildStat(context, Icons.battery_full, "Battery", "${device.battery}%", Colors.green),
                        _buildStat(context, Icons.network_wifi, "Signal", device.signal, Colors.blue),
                        _buildStat(context, Icons.social_distance, "Distance", "Nearby", Colors.orange),
                        _buildStat(context, Icons.access_time, "Last Seen", "Just now", Colors.purple),
                      ],
                    ),
                    SizedBox(height: Responsive.h(context, 0.05)),
                    PrimaryButton(
                      text: "Start Navigation",
                      onPressed: () {},
                    ),
                    SizedBox(height: Responsive.h(context, 0.02)),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 0.02)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.radius(context, 16))),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => RingScreen(device: device)));
                        },
                        icon: const Icon(Icons.volume_up, color: Colors.blue),
                        label: const Text("Ring Device", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                      ),
                    ),
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
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: Responsive.font(context, 3.5))),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: Responsive.font(context, 3))),
      ],
    );
  }
}
