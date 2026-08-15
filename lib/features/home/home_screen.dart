import 'package:flutter/material.dart';

import '../../services/device_service.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/device_card.dart';
import '../../models/device_model.dart';
import '../add_device/add_device_screen.dart';
import '../device_overview/device_overview_screen.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/empty_state.dart';
import 'widgets/stats_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DeviceService _deviceService = DeviceService();


  List<DeviceModel> devices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      final loadedDevices = await _deviceService.getDevices();


      if (!mounted) return;


      setState(() {
        devices = loadedDevices;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;


      setState(() {
        isLoading = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load devices: $e',
          ),
        ),
      );
    }
  }


  Future<void> _deleteDevice(String id) async {
    try {
      await _deviceService.deleteDevice(id);


      if (!mounted) return;


      setState(() {
        devices.removeWhere((d) => d.id == id);
      });
    } catch (e) {
      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete device: $e',
          ),
        ),
      );
    }
  }

  Future<void> _renameDevice(
    String id,
    String newName,
  ) async {
    final index = devices.indexWhere(
      (device) => device.id == id,
    );


    if (index == -1) return;


    final oldDevice = devices[index];


    final updatedDevice = DeviceModel(
      id: oldDevice.id,
      name: newName,
      connected: oldDevice.connected,
      battery: oldDevice.battery,
      signal: oldDevice.signal,
      lastSeen: oldDevice.lastSeen,
      imagePath: oldDevice.imagePath,
      rssi: oldDevice.rssi,
      bleId: oldDevice.bleId,
    );


    try {
      await _deviceService.updateDevice(updatedDevice);


      if (!mounted) return;


      setState(() {
        devices[index] = updatedDevice;
      });
    } catch (e) {
      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to rename device: $e',
          ),
        ),
      );
    }
  }

  Future<void> _navigateToAddDevice() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddDeviceScreen(
          savedDevices: devices,
        ),
      ),
    );


    if (result == null) return;


    final device = DeviceModel(
      id: "esp32${DateTime.now().millisecondsSinceEpoch}",
      name: result["name"] ?? "NO NAME",
      connected: true,
      battery: 82,
      signal: "Excellent",
      lastSeen: "Just now",
      imagePath: result["imagePath"],
      bleId: result["bleId"],
      rssi: result["rssi"] ?? -55,
    );


    try {
      await _deviceService.addDevice(device);


      if (!mounted) return;


      setState(() {
        devices.add(device);
      });
    } catch (e) {
      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save device: $e',
          ),
        ),
      );
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
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.0,
              0.38,
              1.0,
            ],
            colors: [
              Color(0xFFEAF4FF),
              Color(0xFFF8FBFF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
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

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(context, 0.045),
                  vertical: Responsive.h(context, 0.018),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFEAF2FF),
                      Color(0xFFF4F0FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    Responsive.radius(context, 22),
                  ),
                  border: Border.all(
                    color: const Color(0xFFE2E9F8),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getGreeting()}, $userName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle(context).copyWith(
                        fontSize: Responsive.font(context, 4.8),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    SizedBox(
                      height: Responsive.h(context, 0.007),
                    ),

                    Text(
                      getSubtitle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.subtitle(context).copyWith(
                        fontSize: Responsive.font(context, 3.2),
                        color: const Color(0xFF667085),
                      ),
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
                        imagePath: device.imagePath,
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
                                onRename: (newName) {
                                  _renameDevice(
                                    device.id,
                                    newName,
                                  );
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
      ),
    );
  }
}