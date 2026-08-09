import 'package:flutter/material.dart';
import 'devices_screen.dart';
import 'alerts_screen.dart';
import '../utils/responsive.dart';

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

        height: Responsive.h(context, 0.10),

        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,

        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.devices_outlined,
              size: Responsive.w(context, 0.06),
            ),

            selectedIcon: Icon(
              Icons.devices,
              color: const Color(0xFF6C63FF),
              size: Responsive.w(context, 0.06),
            ),

            label: 'Devices',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.notifications_outlined,
              size: Responsive.w(context, 0.06),
            ),

            selectedIcon: Icon(
              Icons.notifications,
              color: const Color(0xFF6C63FF),
              size: Responsive.w(context, 0.06),
            ),

            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}