import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';

class BleScanScreen extends StatefulWidget {
  const BleScanScreen({super.key});

  @override
  State<BleScanScreen> createState() => _BleScanScreenState();
}

class _BleScanScreenState extends State<BleScanScreen> {
  final List<String> devices = [
    "ESP32_Backpack",
    "ESP32_Wallet",
    "ESP32_Keys",
    "ESP32_Laptop",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          "Scan Devices",
          style: AppTextStyles.heading(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Responsive.w(context, 0.06)),
        child: Column(
          children: [
            SizedBox(height: Responsive.h(context, 0.03)),

            Icon(
              Icons.bluetooth_searching,
              size: Responsive.font(context, 8),
              color: Colors.blue,
            ),

            SizedBox(height: Responsive.h(context, 0.02)),

            Text(
              "Nearby Devices",
              style: AppTextStyles.sectionTitle(context),
            ),

            SizedBox(height: Responsive.h(context, 0.03)),

            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.bluetooth),
                      ),
                      title: Text(
                        devices[index],
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      subtitle: const Text("Tap to connect"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context, devices[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}