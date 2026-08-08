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
            Responsive.radius(context, 18),
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
            // DEVICE HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26, // Slightly larger than 22 to match the old Container feel
                  backgroundColor: Colors.blue.shade50,
                  backgroundImage: imagePath != null && imagePath!.isNotEmpty
                      ? FileImage(File(imagePath!))
                      : null,
                  child: imagePath == null || imagePath!.isEmpty
                      ? Icon(
                          _getDeviceIcon(displayName),
                          color: Colors.blue,
                          size: 27,
                        )
                      : null,
                ),

                SizedBox(
                  width: Responsive.w(context, 0.035),
                ),

                // DEVICE NAME + STATUS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        connected
                            ? 'Connected'
                            : 'Disconnected',
                        style: TextStyle(
                          color: connected
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
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
              children: [
                Expanded(
                  child: Text(
                    'Last synced • $lastSeen',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        battery > 20
                            ? Icons.battery_full
                            : Icons.battery_alert,
                        size: 17,
                        color: battery > 20
                            ? Colors.green.shade700
                            : Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$battery%',
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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
