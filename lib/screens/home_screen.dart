import 'package:flutter/material.dart';
import 'devices_screen.dart';
import 'alerts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DevicesScreen(),
    const AlertsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        backgroundColor: Colors.white,

        indicatorColor: const Color(0xFFE9E6FF),

        height: screenWidth < 360 ? 64 : 80,

        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.devices_outlined,
              size: screenWidth < 360 ? 21 : 24,
            ),

            selectedIcon: Icon(
              Icons.devices,
              color: const Color(0xFF6C63FF),
              size: screenWidth < 360 ? 21 : 24,
            ),

            label: 'Devices',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.notifications_outlined,
              size: screenWidth < 360 ? 21 : 24,
            ),

            selectedIcon: Icon(
              Icons.notifications,
              color: const Color(0xFF6C63FF),
              size: screenWidth < 360 ? 21 : 24,
            ),

            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}