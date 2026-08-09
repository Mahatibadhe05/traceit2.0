import 'package:flutter/material.dart';
import 'alert_details_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> alerts = [
    {
      'title': 'Moving Away Alert',
      'device': 'Backpack',
      'time': '2 min ago',
      'type': 'Moving Away',
      'icon': Icons.notifications,
      'color': const Color(0xFFFF4F4F),
    },
    {
      'title': 'Left Behind Alert',
      'device': 'Keys',
      'time': '1 hour ago',
      'type': 'Left Behind',
      'icon': Icons.key,
      'color': const Color(0xFFFFB020),
    },
    {
      'title': 'Connection Lost',
      'device': 'Wallet',
      'time': '3 hours ago',
      'type': 'Connection Lost',
      'icon': Icons.notifications,
      'color': const Color(0xFFFF4F4F),
    },
    {
      'title': 'Low Battery Alert',
      'device': 'Glasses',
      'time': '1 day ago',
      'type': 'Low Battery',
      'icon': Icons.remove_red_eye,
      'color': const Color(0xFF0084BB),
    },
  ];

  List<Map<String, dynamic>> get filteredAlerts {
    if (selectedFilter == 'All') {
      return alerts;
    }

    return alerts
        .where((alert) => alert['type'] == selectedFilter)
        .toList();
  }

  void showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        final filters = [
          'All',
          'Moving Away',
          'Left Behind',
          'Connection Lost',
          'Low Battery',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...filters.map(
                  (filter) => ListTile(
                    title: Text(filter),
                    trailing: selectedFilter == filter
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFF6C63FF),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openAlertDetails(Map<String, dynamic> alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlertDetailsScreen(
          title: alert['title'],
          device: alert['device'],
          time: alert['time'],
          icon: alert['icon'],
          iconColor: alert['color'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding =
        screenWidth < 360 ? 14.0 : 20.0;

    final titleFontSize =
        screenWidth < 360 ? 21.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Alerts',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          TextButton.icon(
            onPressed: showFilterMenu,

            icon: Icon(
              Icons.filter_alt_outlined,
              size: screenWidth < 360 ? 16 : 18,
              color: const Color(0xFF6C63FF),
            ),

            label: Text(
              'Filter',
              style: TextStyle(
                color: const Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 360 ? 12 : 14,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Text(
                    'All Alerts',
                    style: TextStyle(
                      fontSize:
                          screenWidth < 360 ? 15 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),

                  const Spacer(),

                  if (selectedFilter != 'All')
                    Flexible(
                      child: Text(
                        selectedFilter,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              screenWidth < 360 ? 11 : 12,
                          color:
                              const Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 15),

              Expanded(
                child: filteredAlerts.isEmpty
                    ? const Center(
                        child: Text(
                          'No alerts found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),

                        itemCount:
                            filteredAlerts.length,

                        itemBuilder:
                            (context, index) {
                          final alert =
                              filteredAlerts[index];

                          return _alertCard(
                            screenWidth: screenWidth,
                            icon: alert['icon'],
                            iconColor: alert['color'],
                            title: alert['title'],
                            device: alert['device'],
                            time: alert['time'],
                            onTap: () =>
                                openAlertDetails(
                              alert,
                            ),
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

  Widget _alertCard({
    required double screenWidth,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String device,
    required String time,
    required VoidCallback onTap,
  }) {
    final cardPadding =
        screenWidth < 360 ? 12.0 : 16.0;

    final iconBoxSize =
        screenWidth < 360 ? 44.0 : 48.0;

    final iconSize =
        screenWidth < 360 ? 22.0 : 24.0;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: EdgeInsets.all(cardPadding),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.05),
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
                color:
                    iconColor.withValues(alpha: 0.12),
                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            ),

            SizedBox(
              width: screenWidth < 360 ? 9 : 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize:
                          screenWidth < 360 ? 14 : 15,
                      fontWeight: FontWeight.bold,
                      color:
                          const Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    device,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize:
                          screenWidth < 360 ? 12 : 13,
                      color:
                          const Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    time,
                    style: TextStyle(
                      fontSize:
                          screenWidth < 360 ? 10 : 11,
                      color:
                          const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}