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
  final List<Map<String, dynamic>> devices = [
    {
      "name": "ESP32_Backpack",
      "id": "BLE_ESP32_001",
      "rssi": -48,
    },
    {
      "name": "ESP32_Wallet",
      "id": "BLE_ESP32_002",
      "rssi": -62,
    },
    {
      "name": "ESP32_Keys",
      "id": "BLE_ESP32_003",
      "rssi": -76,
    },
    {
      "name": "ESP32_Laptop",
      "id": "BLE_ESP32_004",
      "rssi": -88,
    },
  ];

  String _getSignalStatus(int rssi) {
    if (rssi >= -55) {
      return "Very Close";
    } else if (rssi >= -70) {
      return "Close";
    } else if (rssi >= -85) {
      return "Far";
    } else {
      return "Weak Signal";
    }
  }

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
                        devices[index]["name"],
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      subtitle: Text(
                        "${_getSignalStatus(devices[index]["rssi"])} • "
                        "${devices[index]["rssi"]} dBm",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(
                          context,
                          {
                            "name": devices[index]["name"],
                            "id": devices[index]["id"],
                            "rssi": devices[index]["rssi"],
                          },
                        );
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