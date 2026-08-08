import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../models/device_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../locate/locate_screen.dart';
import '../ring/ring_screen.dart';
import '../device_information/device_information_screen.dart';

class DeviceOverviewScreen extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onDelete;
  final Function(String newName)? onRename;

  const DeviceOverviewScreen({
    super.key,
    required this.device,
    this.onDelete,
    this.onRename,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _RenameDeviceScreen(
                      currentName: device.name,
                      onSave: onRename,
                    ),
                  ),
                );
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
                radius: Responsive.w(context, 0.15),
                backgroundColor: Colors.blue.shade50,
                backgroundImage:
                    device.imagePath != null && device.imagePath!.isNotEmpty
                        ? FileImage(File(device.imagePath!))
                        : null,
                child: device.imagePath == null || device.imagePath!.isEmpty
                    ? Icon(
                        Icons.devices,
                        size: Responsive.w(context, 0.15),
                        color: Colors.blue,
                      )
                    : null,
              ),
            ),
            ),
            
            SizedBox(
              height: Responsive.h(context, 0.025),
            ),
            
            Text(
              device.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
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
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Battery",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${device.battery}%",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 12),
            
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: device.battery / 100,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFE5E7EB),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 0.03)),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            
                  const SizedBox(height: 14),
            
                  _StatusRow(
                    icon: Icons.bluetooth,
                    label: "Connection",
                    value: device.connected
                        ? "Connected"
                        : "Disconnected",
                  ),
            
                  const Divider(height: 22),
            
                  _StatusRow(
                    icon: Icons.network_wifi,
                    label: "BLE Signal",
                    value: device.signal,
                  ),
            
                  const Divider(height: 22),
            
                  _StatusRow(
                    icon: Icons.location_on_outlined,
                    label: "Last Seen",
                    value: device.lastSeen,
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
            
            const SizedBox(height: 24),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "More",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceInformationScreen(
                      device: device,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                      ),
                    ),
            
                    const SizedBox(width: 14),
            
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Device Information",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "View tracker details",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
            
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
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

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.blue,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}

class _RenameDeviceScreen extends StatefulWidget {
  final String currentName;
  final Function(String newName)? onSave;

  const _RenameDeviceScreen({
    required this.currentName,
    required this.onSave,
  });

  @override
  State<_RenameDeviceScreen> createState() => _RenameDeviceScreenState();
}

class _RenameDeviceScreenState extends State<_RenameDeviceScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();

    if (name.isEmpty) return;

    widget.onSave?.call(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Rename Device"),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          Responsive.w(context, 0.06),
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Device name",
                hintText: "Enter device name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(
              height: Responsive.h(context, 0.03),
            ),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
