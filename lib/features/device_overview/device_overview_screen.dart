import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../models/device_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../locate/locate_screen.dart';
import '../ring/ring_screen.dart';

class DeviceOverviewScreen extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onDelete;

  const DeviceOverviewScreen({
    super.key,
    required this.device,
    this.onDelete,
  });

  IconData getDeviceIcon(String name) {
    final lower = name.toLowerCase();
  
    if (lower.contains("backpack")) return Icons.backpack;
    if (lower.contains("wallet")) return Icons.wallet;
    if (lower.contains("key")) return Icons.key;
    if (lower.contains("laptop")) return Icons.laptop_mac;
    if (lower.contains("ear")) return Icons.headphones;
  
    return Icons.backpack;
  }

  Widget _statusRow(
    IconData icon,
    Color color,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
  
          Icon(
            icon,
            color: color,
            size: 20,
          ),
  
          const SizedBox(width: 14),
  
          Expanded(
            child: Text(title),
          ),
  
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        Responsive.radius(context, 18),
      ),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          Responsive.w(context, 0.05),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, 18),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
  
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
  
            SizedBox(width: Responsive.w(context, 0.04)),
  
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
  
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
  
                  const SizedBox(height: 4),
  
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
  
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Text(
          device.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "rename") {
                // TODO
              }
        
              if (value == "delete") {
                if (onDelete != null) {
                  onDelete!();
                  Navigator.pop(context); // Pop back to Dashboard
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: "rename",
                child: Text("Rename"),
              ),
              PopupMenuItem(
                value: "delete",
                child: Text("Delete Device"),
              ),
            ],
          )
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(
          Responsive.w(context, 0.05),
        ),

        child: Column(
          children: [

            AnimatedScale(
              duration: const Duration(milliseconds: 500),
              scale: 1,
              child: CircularPercentIndicator(
              radius: Responsive.w(context, 0.17),
              lineWidth: 6,
              percent: device.battery / 100,
              animation: true,
              animationDuration: 1000,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: device.battery > 60
                  ? Colors.green
                  : device.battery > 25
                      ? Colors.orange
                      : Colors.red,
              backgroundColor: Colors.grey.shade200,
            
              center: CircleAvatar(
                radius: Responsive.w(context, 0.12),
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  getDeviceIcon(device.name),
                  size: Responsive.w(context, 0.11),
                  color: Colors.blue,
                ),
              ),
            ),
            ),
            
            SizedBox(
              height: Responsive.h(context, 0.025),
            ),
            
            Text(
              device.name,
              style: TextStyle(
                fontSize: Responsive.font(context, 0.055),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            
            SizedBox(
              height: Responsive.h(context, 0.015),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: device.connected ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    color: device.connected ? Colors.green.shade700 : Colors.red.shade700,
                    size: 10,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    device.connected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: device.connected ? Colors.green.shade700 : Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 0.04)),
            
            Container(
              padding: EdgeInsets.all(Responsive.w(context, 0.05)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 18),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
            
                  Row(
                    children: [
                      const Icon(
                        Icons.battery_full,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Battery",
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      const Spacer(),
                      Text(
                        "${device.battery}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
            
                  SizedBox(height: Responsive.h(context, 0.02)),
            
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: device.battery / 100,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 0.03)),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                Responsive.w(context, 0.05),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Status",
                    style: AppTextStyles.sectionTitle(context),
                  ),

                  SizedBox(height: Responsive.h(context, 0.02)),

                  _statusRow(
                    Icons.bluetooth_connected,
                    Colors.green,
                    "Connection",
                    device.connected ? "Connected" : "Disconnected",
                  ),

                  Divider(
                    height: 20,
                    color: Colors.grey.shade200,
                  ),

                  _statusRow(
                    Icons.network_wifi,
                    Colors.blue,
                    "BLE Signal",
                    device.signal.isEmpty ? "Unknown" : device.signal,
                  ),

                  Divider(
                    height: 20,
                    color: Colors.grey.shade200,
                  ),

                  _statusRow(
                    Icons.location_on_outlined,
                    Colors.redAccent,
                    "Last Seen",
                    device.lastSeen.isEmpty ? "Never" : device.lastSeen,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: Responsive.h(context, 0.035)),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Actions",
                style: AppTextStyles.sectionTitle(context),
              ),
            ),
            
            SizedBox(height: Responsive.h(context, 0.02)),
            
            actionCard(
              context: context,
              icon: Icons.volume_up,
              color: Colors.blue,
              title: "Ring Device",
              subtitle: "Play a sound to locate your tracker",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RingScreen(device: device),
                  ),
                );
              },
            ),
            
            SizedBox(height: Responsive.h(context, 0.018)),
            
            actionCard(
              context: context,
              icon: Icons.location_on,
              color: Colors.green,
              title: "Locate Device",
              subtitle: "View live location and proximity",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocateScreen(device: device),
                  ),
                );
              },
            ),
            
            SizedBox(height: Responsive.h(context, 0.035)),
            
            actionCard(
              context: context,
              icon: Icons.info_outline,
              color: Colors.orange,
              title: "Device Information",
              subtitle: "Firmware, Bluetooth details and settings",
              onTap: () {
                // We'll connect this screen next
              },
            ),

            SizedBox(
              height: Responsive.h(context, 0.05),
            ),

          ],
        ),
      ),
    );
  }
}
