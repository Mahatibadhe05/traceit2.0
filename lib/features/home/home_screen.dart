import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/device_card.dart';
import '../../models/device_model.dart';
import '../add_device/add_device_screen.dart';
import '../device_overview/device_overview_screen.dart';
import '../locate/locate_screen.dart';
import '../ring/ring_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/empty_state.dart';
import 'widgets/stats_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DeviceModel> devices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _clearData();
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('devices');

    setState(() {
      devices.clear();
      isLoading = false;
    });
  }

  Future<void> _loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? devicesJson = prefs.getString('devices');
    
    if (devicesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(devicesJson);
        setState(() {
          devices = decoded.map((e) => DeviceModel.fromJson(e)).toList();
          isLoading = false;
        });
        return;
      } catch (e) {
        // If JSON parsing fails, fallback to empty list
      }
    }
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(devices.map((e) => e.toJson()).toList());
    await prefs.setString('devices', encoded);
  }

  void _deleteDevice(String id) {
    setState(() {
      devices.removeWhere((d) => d.id == id);
    });
    _saveDevices();
  }

  Future<void> _renameDevice(
    String id,
    String newName,
  ) async {
    final index = devices.indexWhere(
      (device) => device.id == id,
    );

    if (index == -1) return;

    setState(() {
      devices[index] = DeviceModel(
        id: devices[index].id,
        name: newName,
        connected: devices[index].connected,
        battery: devices[index].battery,
        signal: devices[index].signal,
        lastSeen: devices[index].lastSeen,
      );
    });

    await _saveDevices();
  }

  Future<void> _navigateToAddDevice() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddDeviceScreen(),
      ),
    );

    print("RESULT = $result");

    if (result != null) {
      final device = DeviceModel(
        id: "esp32${DateTime.now().millisecondsSinceEpoch}",
        name: result["name"] ?? "NO NAME",
        connected: true,
        battery: 82,
        signal: "Excellent",
        lastSeen: "Just now",
      );

      print("DEVICE NAME = ${device.name}");

      setState(() {
        devices.add(device);
      });

      await _saveDevices();
    }
  }

  String userName = "Mahati";

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String getSubtitle() {
    if (devices.isEmpty) {
      return "Add your first smart tracker.";
    }

    final connected = devices.where((d) => d.connected).length;

    if (connected == devices.length) {
      return "All your devices are connected.";
    }

    return "$connected of ${devices.length} devices are connected.";
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 0.03),
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.h(context, 0.04)),
              
              DashboardHeader(
                hasDevice: devices.isNotEmpty,
                onAddDevice: _navigateToAddDevice,
              ),

              SizedBox(height: Responsive.h(context, 0.025)),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "👋 ${getGreeting()}, $userName",
                      style: AppTextStyles.sectionTitle(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 0.005)),
                    Text(
                      getSubtitle(),
                      style: AppTextStyles.subtitle(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Responsive.h(context, 0.03)),

              if (devices.isNotEmpty) ...[
                StatsChips(
                  deviceCount: devices.length,
                  connectedCount: devices.where((d) => d.connected).length,
                ),

                SizedBox(height: Responsive.h(context, 0.02)),

                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return DeviceCard(
                        deviceName: device.name,
                        connected: device.connected,
                        battery: device.battery,
                        lastSeen: device.lastSeen,
                        signal: device.signal,
                      
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeviceOverviewScreen(
                                device: device,
                                onDelete: () {
                                  _deleteDevice(device.id);
                                },
                              ),
                            ),
                          );
                        },
                      
                        onDelete: () {
                          _deleteDevice(device.id);
                        },
                      
                        onRename: (newName) {
                          _renameDevice(
                            device.id,
                            newName,
                          );
                        },
                      );
                    },
                  ),
                ),
              ] else
                Expanded(
                  child: EmptyState(
                    onAddDevice: _navigateToAddDevice,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}