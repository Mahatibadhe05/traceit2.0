import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(
      child: Text(
        "Select a device to locate",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    const Center(child: Text("Alerts")),
    const Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE3F0FF),
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: Color(0xFF526A8A),
            ),
            selectedIcon: Icon(
              Icons.dashboard,
              color: Color(0xFF1769E0),
            ),
            label: 'Dashboard',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.location_on_outlined,
              color: Color(0xFF526A8A),
            ),
            selectedIcon: Icon(
              Icons.location_on,
              color: Color(0xFF1769E0),
            ),
            label: 'Locate',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF526A8A),
            ),
            selectedIcon: Icon(
              Icons.notifications_rounded,
              color: Color(0xFF1769E0),
            ),
            label: 'Alerts',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              color: Color(0xFF526A8A),
            ),
            selectedIcon: Icon(
              Icons.settings,
              color: Color(0xFF1769E0),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
