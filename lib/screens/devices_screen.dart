import 'package:flutter/material.dart';
import 'add_device_screen.dart';

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
                size: 55,
                color: device['color'],
              ),
              const SizedBox(height: 15),
              Text(
                device['connected']
                    ? 'Connected'
                    : 'Disconnected',
              ),
              const SizedBox(height: 8),
              Text('Battery: ${device['battery']}%'),
              const SizedBox(height: 8),
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
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 20.0;

    final cardPadding = screenWidth < 360 ? 12.0 : 16.0;

    final iconBoxSize = screenWidth < 360 ? 46.0 : 52.0;

    final iconSize = screenWidth < 360 ? 24.0 : 28.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Devices',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: screenWidth < 360 ? 21 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: addDevice,
            icon: const Icon(
              Icons.add,
              color: Color(0xFF6C63FF),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Devices',
                style: TextStyle(
                  fontSize: screenWidth < 360 ? 15 : 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: devices.length + 1,

                  itemBuilder: (context, index) {
                    if (index == devices.length) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),

                        child: SizedBox(
                          height: screenWidth < 360 ? 48 : 52,
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            onPressed: addDevice,

                            icon: const Icon(Icons.add),

                            label: Text(
                              'Add New Device',
                              style: TextStyle(
                                fontSize:
                                    screenWidth < 360 ? 14 : 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return _deviceCard(
                      devices[index],
                      index,
                      cardPadding,
                      iconBoxSize,
                      iconSize,
                      screenWidth,
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
    double cardPadding,
    double iconBoxSize,
    double iconSize,
    double screenWidth,
  ) {
    final bool connected = device['connected'];
    final int battery = device['battery'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: EdgeInsets.all(cardPadding),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,

            decoration: BoxDecoration(
              color: device['color'].withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              device['icon'],
              color: device['color'],
              size: iconSize,
            ),
          ),

          SizedBox(
            width: screenWidth < 360 ? 9 : 14,
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
                    fontSize: screenWidth < 360 ? 15 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,

                      decoration: BoxDecoration(
                        color: connected
                            ? const Color(0xFF28C76F)
                            : const Color(0xFFFF4F4F),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Flexible(
                      child: Text(
                        connected
                            ? 'Connected'
                            : 'Disconnected',

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize:
                              screenWidth < 360 ? 11 : 12,
                          color: connected
                              ? const Color(0xFF28C76F)
                              : const Color(0xFFFF4F4F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: screenWidth < 360 ? 7 : 12,
                    ),

                    const Icon(
                      Icons.battery_full,
                      size: 15,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 3),

                    Text(
                      '$battery%',
                      style: TextStyle(
                        fontSize:
                            screenWidth < 360 ? 11 : 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.bluetooth,
            color: Colors.grey,
            size: 20,
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