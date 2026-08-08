import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  Map<String, dynamic>? selectedBleDevice;
  File? _deviceImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _deviceImage = File(image.path);
      });
    }
  }

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
                    SizedBox(
                      height: Responsive.h(context, 0.035),
                    ),
                    
                    Text(
                      "Device Image",
                      style: AppTextStyles.sectionTitle(context),
                    ),
                    
                    SizedBox(
                      height: Responsive.h(context, 0.015),
                    ),
                    
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: Responsive.h(context, 0.22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, 18),
                          ),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: _deviceImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: Responsive.w(context, 0.10),
                                    color: Colors.grey.shade500,
                                  ),
                    
                                  SizedBox(
                                    height: Responsive.h(context, 0.012),
                                  ),
                    
                                  Text(
                                    "Add a photo",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                    
                                  SizedBox(
                                    height: Responsive.h(context, 0.005),
                                  ),
                    
                                  Text(
                                    "Tap to take a photo or choose from gallery",
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: Responsive.font(context, 0.03),
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Responsive.radius(context, 18),
                                ),
                                child: Image.file(
                                  _deviceImage!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                            final device = await Navigator.push<Map<String, dynamic>>(
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
                          subtitle: Text(
                            "${selectedBleDevice!["id"]} • "
                            "${selectedBleDevice!["rssi"]} dBm",
                          ),
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
                            final name = nameController.text.trim();
                          
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a device name"),
                                ),
                              );
                              return;
                            }
                          
                            if (_deviceImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please add a photo of your device"),
                                ),
                              );
                              return;
                            }
                          
                            if (selectedBleDevice == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please scan and select your BLE device"),
                                ),
                              );
                              return;
                            }
                          
                            Navigator.pop(
                              context,
                              {
                                "name": name,
                                "bleId": selectedBleDevice!["id"],
                                "rssi": selectedBleDevice!["rssi"],
                                "imagePath": _deviceImage!.path,
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