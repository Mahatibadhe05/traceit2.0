import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../services/ble_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../models/device_model.dart';

const Color _blue = Color(0xFF2563EB);
const Color _blueDark = Color(0xFF1D4ED8);
const Color _textDark = Color(0xFF17233B);
const Color _textGrey = Color(0xFF667085);
const Color _border = Color(0xFFE5EAF2);
const Color _softBlue = Color(0xFFF8FAFF);

class BleScanScreen extends StatefulWidget {
  final List<DeviceModel> savedDevices;

  const BleScanScreen({
    super.key,
    required this.savedDevices,
  });

  @override
  State<BleScanScreen> createState() => _BleScanScreenState();
}

class _BleScanScreenState extends State<BleScanScreen> {
  // ---- UNCHANGED LOGIC ----
  final BleService _bleService = BleService();


  List<ScanResult> _scanResults = [];


  final Map<String, Map<String, dynamic>> _fakeDevices = {
    'CHARM_TEST': {
      'name': 'TraceIt Test Charm',
      'id': 'CHARM_TEST',
      'rssi': -55,
    },
    'FAKE_CHARM_002': {
      'name': 'TraceIt Test Charm 2',
      'id': 'FAKE_CHARM_002',
      'rssi': -68,
    },
  };


  bool _isScanning = false;
  String? _scanError;

  @override
  void initState() {
    super.initState();


    _startBleScan();
  }


  @override
  void dispose() {
    _bleService.dispose();
    super.dispose();
  }


  Future<void> _startBleScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
      _scanError = null;
    });


    final permissionsGranted =
        await _bleService.requestPermissions();


    if (!permissionsGranted) {
      if (!mounted) return;


      setState(() {
        _isScanning = false;
        _scanError = 'Bluetooth permission is required.';
      });


      return;
    }


    try {
      await for (final results
          in _bleService.scanForDevices()) {
        if (!mounted) return;


        setState(() {
          _scanResults = results;
        });
      }
    } catch (e) {
      if (!mounted) return;


      setState(() {
        _scanError = 'Unable to scan for nearby devices.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  DeviceModel? _getAssignedDevice(String bleId) {
    for (final device in widget.savedDevices) {
      if (device.bleId == bleId) {
        return device;
      }
    }

    return null;
  }

  String _getSignalStatus(int rssi) {
    if (rssi >= -55) {
      return "Very Close";
    } else if (rssi >= -70) {
      return "Close";
    } else if (rssi >= -85) {
      return "Far";
    } else {
      return "Weak Signal";
    }
  }
  // ---- END UNCHANGED LOGIC ----

  // ---- purely visual helper: color per signal strength ----
  Color _signalColor(int rssi) {
    if (rssi >= -55) return const Color(0xFF16A34A); // very close - green
    if (rssi >= -70) return _blue; // close - blue
    if (rssi >= -85) return const Color(0xFFF59E0B); // far - amber
    return const Color(0xFFDC2626); // weak - red
  }

  IconData _signalIcon(int rssi) {
    if (rssi >= -55) return Icons.signal_cellular_alt;
    if (rssi >= -70) return Icons.signal_cellular_alt;
    if (rssi >= -85) return Icons.signal_cellular_alt_2_bar;
    return Icons.signal_cellular_alt_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF4FF),
              Color(0xFFF6F8FC),
            ],
            stops: [0.0, 0.22],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.w(context, 0.05),
              vertical: Responsive.h(context, 0.01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Responsive.h(context, 0.015)),

                // ---- Header ----
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: _textDark,
                      ),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select Charm',
                      style: AppTextStyles.heading(context).copyWith(
                        color: _textDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.h(context, 0.03)),

                // ---- Bluetooth badge + section title ----
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Responsive.w(context, 0.05)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _blue.withValues(alpha: 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bluetooth_searching,
                          size: Responsive.font(context, 7),
                          color: _blue,
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 0.016)),
                      Text(
                        "Nearby Charms",
                        style: AppTextStyles.sectionTitle(context).copyWith(
                          color: _textDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Responsive.h(context, 0.028)),

                // ---- Device list ----
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _scanResults.length + _fakeDevices.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: Responsive.h(context, 0.014)),
                    itemBuilder: (context, index) {
                      final isFakeDevice = index >= _scanResults.length;


                      String deviceName;
                      String bleId;
                      int rssi;


                      if (isFakeDevice) {
                        final fakeDeviceIndex = index - _scanResults.length;
                        final fakeDevice = _fakeDevices.values.elementAt(fakeDeviceIndex);


                        deviceName = fakeDevice['name'] as String;
                        bleId = fakeDevice['id'] as String;
                        rssi = fakeDevice['rssi'] as int;
                      } else {
                        final result = _scanResults[index];
                        final bluetoothDevice = result.device;


                        deviceName = bluetoothDevice.platformName.isNotEmpty
                            ? bluetoothDevice.platformName
                            : 'Charm';


                        bleId = bluetoothDevice.remoteId.str;
                        rssi = result.rssi;
                      }

                      final assignedDevice = _getAssignedDevice(bleId);
                      final isAssigned = assignedDevice != null;
                      final statusColor =
                          isAssigned ? const Color(0xFF16A34A) : _signalColor(rssi);

                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: isAssigned
                              ? null
                              : () {
                                  Navigator.pop(
                                    context,
                                    {
                                      "name": deviceName,
                                      "id": bleId,
                                      "rssi": rssi,
                                    },
                                  );
                                },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.w(context, 0.04),
                              vertical: Responsive.h(context, 0.016),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isAssigned
                                    ? const Color(0xFFBBF7D0)
                                    : _border,
                                width: 1,
                              ),
                              color: isAssigned
                                  ? const Color(0xFFF0FDF4)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isAssigned
                                        ? Colors.green.shade50
                                        : _softBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isAssigned
                                        ? Icons.check_circle
                                        : Icons.bluetooth,
                                    color: isAssigned ? Colors.green : _blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isAssigned
                                            ? assignedDevice.name
                                            : deviceName,
                                        style: AppTextStyles.sectionTitle(
                                                context)
                                            .copyWith(
                                          color: _textDark,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          if (!isAssigned)
                                            Container(
                                              width: 6,
                                              height: 6,
                                              margin: const EdgeInsets.only(
                                                  right: 6),
                                              decoration: BoxDecoration(
                                                color: statusColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          Text(
                                            isAssigned
                                                ? "Already connected"
                                                : isFakeDevice
                                                    ? "Test device • $rssi dBm"
                                                    : "${_getSignalStatus(rssi)} • $rssi dBm",
                                            style: TextStyle(
                                              color: isAssigned
                                                  ? const Color(0xFF15803D)
                                                  : _textGrey,
                                              fontSize: 12.5,
                                              fontWeight: isAssigned
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                isAssigned
                                    ? Icon(
                                        Icons.lock_outline,
                                        color: Colors.grey.shade400,
                                        size: 18,
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.grey.shade400,
                                        size: 14,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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