import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../ble/ble_scan_screen.dart';
import '../../core/theme/app_text_styles.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController nameController = TextEditingController();
  String? selectedBleDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.w(context, 0.06)),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.h(context, 0.03)),
                    Text(
  "Add Device",
  style: AppTextStyles.heading(context),
),
                    
                    SizedBox(height: Responsive.h(context, 0.01)),
                    Text(
  "Register a new smart tracker.",
  style: AppTextStyles.subtitle(context),
),
                    SizedBox(height: Responsive.h(context, 0.04)),
                    Text(
  "Device Name",
  style: AppTextStyles.sectionTitle(context),
),
                    SizedBox(height: Responsive.h(context, 0.015)),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "e.g. Backpack",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, 12),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.edit_outlined),
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 0.04)),
                    if (selectedBleDevice == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.h(context, 0.018),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.radius(context, 12),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final device = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BleScanScreen(),
                              ),
                            );

                            if (device != null) {
                              setState(() {
                                selectedBleDevice = device;
                              });
                            }
                          },
                          icon: const Icon(Icons.bluetooth_searching),
                          label: Text(
                            "Scan for BLE Device",
                            style: TextStyle(
                              fontSize: Responsive.font(context, 0.04),
                            ),
                          ),
                        ),
                      ),

                    if (selectedBleDevice != null) ...[
                      SizedBox(height: Responsive.h(context, 0.02)),
                      Card(
                        color: Colors.green.shade50,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, 12),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: const Text("Connected Device"),
                          subtitle: Text(selectedBleDevice!),
                          trailing: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedBleDevice = null;
                              });
                            },
                            child: const Text("Change"),
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 0.03)),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.h(context, 0.018),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.radius(context, 12),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              {
                                "name": nameController.text.trim(),
                                "bleId": selectedBleDevice,
                              },
                            );
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}