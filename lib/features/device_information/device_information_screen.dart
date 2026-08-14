import 'package:flutter/material.dart';

import '../../models/device_model.dart';
import '../../core/utils/responsive.dart';

class DeviceInformationScreen extends StatelessWidget {
  final DeviceModel device;

  const DeviceInformationScreen({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text("Device Information"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoCard(
                title: "Device Name",
                value: device.name,
                icon: Icons.devices_other,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "Device ID",
                value: device.id,
                icon: Icons.fingerprint,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "BLE ID",
                value: device.bleId ?? "Not available",
                icon: Icons.bluetooth,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "RSSI",
                value: "${device.rssi} dBm",
                icon: Icons.signal_cellular_alt,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "Connection",
                value: device.connected
                    ? "Connected"
                    : "Disconnected",
                icon: Icons.bluetooth,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "Battery",
                value: "${device.battery}%",
                icon: Icons.battery_full,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "BLE Signal",
                value: device.signal,
                icon: Icons.network_wifi,
              ),

              const SizedBox(height: 12),

              _InfoCard(
                title: "Last Seen",
                value: device.lastSeen,
                icon: Icons.access_time,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE9EEF7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.018),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 22,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF98A2B3),
                    fontSize: Responsive.font(context, 2.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.004),
                ),

                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF17233B),
                    fontSize: Responsive.font(context, 3.2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
