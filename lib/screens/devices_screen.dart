import 'package:flutter/material.dart';
import 'add_device_screen.dart';
import '../utils/responsive.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<Map<String, dynamic>> devices = [
    {
      'name': 'Backpack',
      'icon': Icons.backpack,
      'color': const Color(0xFF6C63FF),
      'connected': true,
      'battery': 82,
    },
    {
      'name': 'Wallet',
      'icon': Icons.account_balance_wallet,
      'color': const Color(0xFFFF6B4A),
      'connected': false,
      'battery': 45,
    },
    {
      'name': 'Keys',
      'icon': Icons.key,
      'color': const Color(0xFFFFB020),
      'connected': true,
      'battery': 67,
    },
    {
      'name': 'Glasses',
      'icon': Icons.remove_red_eye,
      'color': const Color(0xFF0084BB),
      'connected': true,
      'battery': 90,
    },
  ];

  Future<void> addDevice() async {
    final deviceName = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDeviceScreen(),
      ),
    );

    if (deviceName != null && deviceName.trim().isNotEmpty) {
      setState(() {
        devices.add({
          'name': deviceName.trim(),
          'icon': Icons.devices,
          'color': const Color(0xFF6C63FF),
          'connected': true,
          'battery': 100,
        });
      });
    }
  }

  void showDeviceInfo(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(device['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                device['icon'],
                size: Responsive.w(context, 0.14),
                color: device['color'],
              ),
              SizedBox(
                height: Responsive.h(context, 0.02),
              ),
              Text(
                device['connected']
                    ? 'Connected'
                    : 'Disconnected',
              ),
              SizedBox(
                height: Responsive.h(context, 0.01),
              ),
              Text(
                'Battery: ${device['battery']}%',
              ),
              SizedBox(
                height: Responsive.h(context, 0.01),
              ),
              const Text('Bluetooth device'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Devices',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: Responsive.font(context, 6),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: addDevice,
            icon: Icon(
              Icons.add,
              color: const Color(0xFF6C63FF),
              size: Responsive.w(context, 0.06),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, 0.05),
            vertical: Responsive.h(context, 0.025),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Devices',
                style: TextStyle(
                  fontSize: Responsive.font(context, 4.1),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(
                height: Responsive.h(context, 0.018),
              ),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: devices.length + 1,

                  itemBuilder: (context, index) {
                    if (index == devices.length) {
                      return SizedBox(
                        width: double.infinity,
                        height: Responsive.h(context, 0.065),

                        child: ElevatedButton.icon(
                          onPressed: addDevice,

                          icon: const Icon(Icons.add),

                          label: Text(
                            'Add New Device',
                            style: TextStyle(
                              fontSize:
                                  Responsive.font(context, 3.8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Responsive.radius(context, 0.035),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return _deviceCard(
                      devices[index],
                      index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceCard(
    Map<String, dynamic> device,
    int index,
  ) {
    final bool connected = device['connected'];
    final int battery = device['battery'];

    return Container(
      margin: EdgeInsets.only(
        bottom: Responsive.h(context, 0.018),
      ),

      padding: EdgeInsets.all(
        Responsive.w(context, 0.04),
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 0.04),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: Responsive.w(context, 0.025),
            offset: Offset(
              0,
              Responsive.h(context, 0.004),
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: Responsive.w(context, 0.13),
            height: Responsive.w(context, 0.13),

            decoration: BoxDecoration(
              color: device['color'].withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(
                Responsive.radius(context, 0.035),
              ),
            ),

            child: Icon(
              device['icon'],
              color: device['color'],
              size: Responsive.w(context, 0.07),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.035),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: Responsive.font(context, 4.1),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.006),
                ),

                Row(
                  children: [
                    Container(
                      width: Responsive.w(context, 0.02),
                      height: Responsive.w(context, 0.02),

                      decoration: BoxDecoration(
                        color: connected
                            ? const Color(0xFF28C76F)
                            : const Color(0xFFFF4F4F),
                        shape: BoxShape.circle,
                      ),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 0.015),
                    ),

                    Flexible(
                      child: Text(
                        connected
                            ? 'Connected'
                            : 'Disconnected',
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize:
                              Responsive.font(context, 3.1),
                          color: connected
                              ? const Color(0xFF28C76F)
                              : const Color(0xFFFF4F4F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: Responsive.w(context, 0.025),
                    ),

                    Icon(
                      Icons.battery_full,
                      size: Responsive.w(context, 0.038),
                      color: Colors.grey,
                    ),

                    SizedBox(
                      width: Responsive.w(context, 0.008),
                    ),

                    Text(
                      '$battery%',
                      style: TextStyle(
                        fontSize:
                            Responsive.font(context, 3.1),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Icon(
            Icons.bluetooth,
            color: Colors.grey,
            size: Responsive.w(context, 0.05),
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'info') {
                showDeviceInfo(device);
              }

              if (value == 'remove') {
                setState(() {
                  devices.removeAt(index);
                });
              }
            },

            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'info',
                child: Text('Device Info'),
              ),
              PopupMenuItem(
                value: 'remove',
                child: Text('Remove Device'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}