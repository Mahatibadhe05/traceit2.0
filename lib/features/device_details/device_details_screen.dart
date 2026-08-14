import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';
import '../../core/widgets/primary_button.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback onDelete;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
    required this.onDelete,
  });

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 0.015)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.subtitle(context)),
          Text(
            value,
            style: AppTextStyles.sectionTitle(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.w(context, 0.06)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: Responsive.w(context, 0.15),
                backgroundColor: Colors.blue.shade50,
                child: Icon(
                  Icons.backpack,
                  size: Responsive.w(context, 0.15),
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: Responsive.h(context, 0.04)),
              Container(
                padding: EdgeInsets.all(Responsive.w(context, 0.05)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Responsive.radius(context, 20)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow(context, "Battery", "${device.battery}%"),
                    const Divider(),
                    _buildDetailRow(context, "Signal", device.signal),
                    const Divider(),
                    _buildDetailRow(context, "Status", device.connected ? "Connected" : "Disconnected"),
                    const Divider(),
                    _buildDetailRow(context, "Firmware", "v1.0"),
                    const Divider(),
                    _buildDetailRow(context, "Hardware ID", device.id),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(context, 0.04)),
              PrimaryButton(
                text: "Rename Device",
                onPressed: () {},
              ),
              SizedBox(height: Responsive.h(context, 0.02)),
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Device"),
                      content: const Text("Are you sure you want to remove this device?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    onDelete();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Delete Device", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
