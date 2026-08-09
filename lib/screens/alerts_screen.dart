import 'package:flutter/material.dart';
import 'alert_details_screen.dart';
import '../utils/responsive.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Responsive.radius(context, 0.06),
          ),
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
            padding: EdgeInsets.symmetric(
              vertical: Responsive.h(context, 0.018),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter Alerts',
                  style: TextStyle(
                    fontSize: Responsive.font(context, 4.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: Responsive.h(context, 0.012),
                ),

                ...filters.map(
                  (filter) => ListTile(
                    title: Text(
                      filter,
                      style: TextStyle(
                        fontSize:
                            Responsive.font(context, 3.8),
                      ),
                    ),

                    trailing: selectedFilter == filter
                        ? Icon(
                            Icons.check,
                            color: const Color(0xFF6C63FF),
                            size: Responsive.w(context, 0.06),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Alerts',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: Responsive.font(context, 6),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          TextButton.icon(
            onPressed: showFilterMenu,

            icon: Icon(
              Icons.filter_alt_outlined,
              size: Responsive.w(context, 0.046),
              color: const Color(0xFF6C63FF),
            ),

            label: Text(
              'Filter',
              style: TextStyle(
                color: const Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
                fontSize: Responsive.font(context, 3.5),
              ),
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
              Row(
                children: [
                  Text(
                    'All Alerts',
                    style: TextStyle(
                      fontSize: Responsive.font(context, 4.1),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),

                  const Spacer(),

                  if (selectedFilter != 'All')
                    Flexible(
                      child: Text(
                        selectedFilter,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize:
                              Responsive.font(context, 3.1),
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(
                height: Responsive.h(context, 0.018),
              ),

              Expanded(
                child: filteredAlerts.isEmpty
                    ? Center(
                        child: Text(
                          'No alerts found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize:
                                Responsive.font(context, 3.8),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),

                        itemCount: filteredAlerts.length,

                        itemBuilder: (context, index) {
                          final alert =
                              filteredAlerts[index];

                          return _alertCard(
                            icon: alert['icon'],
                            iconColor: alert['color'],
                            title: alert['title'],
                            device: alert['device'],
                            time: alert['time'],
                            onTap: () =>
                                openAlertDetails(alert),
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
    required IconData icon,
    required Color iconColor,
    required String title,
    required String device,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
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
              width: Responsive.w(context, 0.123),
              height: Responsive.w(context, 0.123),

              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),

                borderRadius: BorderRadius.circular(
                  Responsive.radius(context, 0.035),
                ),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: Responsive.w(context, 0.062),
              ),
            ),

            SizedBox(
              width: Responsive.w(context, 0.035),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: Responsive.font(context, 3.8),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),

                  SizedBox(
                    height: Responsive.h(context, 0.006),
                  ),

                  Text(
                    device,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: Responsive.font(context, 3.3),
                      color: const Color(0xFF64748B),
                    ),
                  ),

                  SizedBox(
                    height: Responsive.h(context, 0.004),
                  ),

                  Text(
                    time,
                    style: TextStyle(
                      fontSize: Responsive.font(context, 2.8),
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: Responsive.w(context, 0.01),
            ),

            Icon(
              Icons.chevron_right,
              color: const Color(0xFF64748B),
              size: Responsive.w(context, 0.06),
            ),
          ],
        ),
      ),
    );
  }
}