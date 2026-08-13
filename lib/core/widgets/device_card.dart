import 'dart:io';
import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class DeviceCard extends StatelessWidget {
  final VoidCallback? onDelete;
  final ValueChanged<String>? onRename;
  final VoidCallback? onTap;

  final String deviceName;
  final bool connected;
  final int battery;
  final String lastSeen;
  final String signal;
  final String? imagePath;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.connected,
    required this.battery,
    required this.lastSeen,
    required this.signal,
    this.imagePath,
    this.onDelete,
    this.onRename,
    this.onTap,
  });

  IconData _getDeviceIcon(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('backpack')) {
      return Icons.backpack;
    }

    if (lower.contains('wallet')) {
      return Icons.wallet;
    }

    if (lower.contains('key')) {
      return Icons.key;
    }

    if (lower.contains('laptop')) {
      return Icons.laptop_mac;
    }

    if (lower.contains('bag')) {
      return Icons.shopping_bag;
    }

    if (lower.contains('earbud')) {
      return Icons.headphones;
    }

    return Icons.devices_other;
  }

  Future<void> _showRenameDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: deviceName,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Device'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter device name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newName != null && newName.isNotEmpty) {
      onRename?.call(newName);
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Device'),
          content: const Text(
            'Are you sure you want to remove this device?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = deviceName.trim().isEmpty
        ? 'Unnamed Device'
        : deviceName.trim();

    final double imageRadius = Responsive.w(context, 0.095);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: Responsive.h(context, 0.02),
        ),
        padding: EdgeInsets.all(
          Responsive.w(context, 0.045),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, 22),
          ),
          border: Border.all(
            color: const Color(0xFFE8EEF8),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DEVICE HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DEVICE IMAGE WITH CONNECTION RING
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: connected
                          ? const Color(0xFF63D391)
                          : const Color(0xFFD1D5DB),
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: imageRadius,
                    backgroundColor: const Color(0xFFF1F5FF),
                    backgroundImage:
                        imagePath != null && imagePath!.isNotEmpty
                            ? FileImage(File(imagePath!))
                            : null,
                    child: imagePath == null || imagePath!.isEmpty
                        ? Icon(
                            _getDeviceIcon(displayName),
                            color: const Color(0xFF246BFE),
                            size: Responsive.w(context, 0.085),
                          )
                        : null,
                  ),
                ),

                SizedBox(
                  width: Responsive.w(context, 0.045),
                ),

                // DEVICE NAME + STATUS
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Responsive.h(context, 0.028),
                      left: Responsive.w(context, 0.005),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(
                          height: Responsive.h(context, 0.008),
                        ),

                        Text(
                          connected ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                            color: connected
                                ? const Color(0xFF31A85B)
                                : const Color(0xFFDC4545),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    color: const Color(0xFF6B7280),
                    size: Responsive.w(context, 0.065),
                  ),
                  onSelected: (value) {
                    if (value == 'rename') {
                      _showRenameDialog(context);
                    }

                    if (value == 'delete') {
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'rename',
                      child: Text('Rename'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Device'),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: Responsive.h(context, 0.025),
            ),

            // DEVICE INFO
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: const Color(0xFF3276E8),
                  size: Responsive.w(context, 0.06),
                ),

                SizedBox(
                  width: Responsive.w(context, 0.025),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last synced',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        lastSeen,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.w(context, 0.035),
                    vertical: Responsive.h(context, 0.012),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EE),
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, 18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        battery > 20
                            ? Icons.battery_full_rounded
                            : Icons.battery_alert_rounded,
                        size: Responsive.w(context, 0.06),
                        color: battery > 20
                            ? const Color(0xFF35B85A)
                            : const Color(0xFFE04444),
                      ),

                      SizedBox(
                        width: Responsive.w(context, 0.02),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$battery%',
                            style: const TextStyle(
                              color: Color(0xFF172033),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'Battery',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
