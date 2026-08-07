import 'package:flutter/material.dart';

import '../../core/utils/responsive.dart';
import '../ble/ble_scan_screen.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_colors.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  String? selectedCategory;

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
                    SizedBox(height: Responsive.h(context, 0.03)),
                    Text(
  "Category",
  style: AppTextStyles.sectionTitle(context),
),
                    SizedBox(height: Responsive.h(context, 0.015)),
                    DropdownButtonFormField<String>(
                      Value: selectedCategory,
                      decoration: InputDecoration(
                        hintText: "Select Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.radius(context, 12),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Backpack",
                          child: Text("🎒 Backpack"),
                        ),
                        DropdownMenuItem(
                          value: "Wallet",
                          child: Text("👛 Wallet"),
                        ),
                        DropdownMenuItem(
                          value: "Keys",
                          child: Text("🔑 Keys"),
                        ),
                        DropdownMenuItem(
                          value: "Laptop",
                          child: Text("💻 Laptop"),
                        ),
                        DropdownMenuItem(
                          value: "Earbuds",
                          child: Text("🎧 Earbuds"),
                        ),
                        DropdownMenuItem(
                          value: "Bag",
                          child: Text("👜 Bag"),
                        ),
                        DropdownMenuItem(
                          value: "Others",
                          child: Text("📦 Others"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    if (selectedCategory == "Others") ...[
                      SizedBox(height: Responsive.h(context, 0.03)),
                      Text(
  "Custom Category",
  style: AppTextStyles.sectionTitle(context),
),
                      SizedBox(height: Responsive.h(context, 0.015)),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.radius(context, 12),
                            ),
                          ),
                          prefixIcon: const Icon(Icons.edit_outlined),
                        ),
                      ),
                    ],
                    SizedBox(height: Responsive.h(context, 0.04)),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BleScanScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bluetooth_searching),
                        label: Text(
                          "Scan for BLE Device",
                          style: TextStyle(
                            fontSize: Responsive.font(context, 0.022),
                          ),
                        ),
                      ),
                    ),
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