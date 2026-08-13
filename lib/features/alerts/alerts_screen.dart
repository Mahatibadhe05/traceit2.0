import 'package:flutter/material.dart';
import 'responsive.dart';
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
      'icon': Icons.directions_walk,
      'color': const Color(0xFFFF5252),
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
      'icon': Icons.bluetooth_disabled,
      'color': const Color(0xFFFF5252),
    },
    {
      'title': 'Low Battery Alert',
      'device': 'Glasses',
      'time': '1 day ago',
      'type': 'Low Battery',
      'icon': Icons.battery_alert,
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
    final filters = [
      'All',
      'Moving Away',
      'Left Behind',
      'Connection Lost',
      'Low Battery',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Responsive.radius(context, 24),
          ),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Responsive.h(context, 0.02),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter Alerts',
                  style: TextStyle(
                    fontSize: Responsive.font(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Responsive.h(context, 0.01),
                ),
                ...filters.map(
                  (filter) {
                    return ListTile(
                      title: Text(
                        filter,
                        style: TextStyle(
                          fontSize: Responsive.font(context, 15),
                        ),
                      ),
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
                    );
                  },
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
          title: alert['title'] as String,
          device: alert['device'] as String,
          time: alert['time'] as String,
          icon: alert['icon'] as IconData,
          iconColor: alert['color'] as Color,
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
            fontSize: Responsive.font(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: Responsive.w(context, 0.02),
            ),
            child: TextButton.icon(
              onPressed: showFilterMenu,
              icon: Icon(
                Icons.filter_alt_outlined,
                size: Responsive.w(context, 0.045),
                color: const Color(0xFF6C63FF),
              ),
              label: Text(
                'Filter',
                style: TextStyle(
                  color: const Color(0xFF6C63FF),
                  fontSize: Responsive.font(context, 13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1000,
            ),
            child: SingleChildScrollView(
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
                          fontSize: Responsive.font(context, 17),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      const Spacer(),

                      if (selectedFilter != 'All')
                        Flexible(
                          child: Text(
                            selectedFilter,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Responsive.font(context, 12),
                              color: const Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(
                    height: Responsive.h(context, 0.02),
                  ),

                  if (filteredAlerts.isEmpty)
                    SizedBox(
                      height: Responsive.h(context, 0.5),
                      child: Center(
                        child: Text(
                          'No alerts found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Responsive.font(context, 15),
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = filteredAlerts[index];

                        return _AlertCard(
                          icon: alert['icon'] as IconData,
                          iconColor: alert['color'] as Color,
                          title: alert['title'] as String,
                          device: alert['device'] as String,
                          time: alert['time'] as String,
                          onTap: () => openAlertDetails(alert),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String device;
  final String time;
  final VoidCallback onTap;

  const _AlertCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.device,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: Responsive.h(context, 0.018),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: Responsive.w(context, 0.02),
            offset: Offset(
              0,
              Responsive.h(context, 0.004),
            ),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, 16),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.w(context, 0.025),
            ),
            child: Row(
              children: [
                Container(
                  width: Responsive.w(context, 0.10),
                  height: Responsive.w(context, 0.10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      Responsive.radius(context, 14),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: Responsive.w(context, 0.05),
                  ),
                ),

                SizedBox(
                  width: Responsive.w(context, 0.025),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Responsive.font(context, 15),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.005),
                      ),

                      Text(
                        device,
                        style: TextStyle(
                          fontSize: Responsive.font(context, 13),
                          color: const Color(0xFF64748B),
                        ),
                      ),

                      SizedBox(
                        height: Responsive.h(context, 0.003),
                      ),

                      Text(
                        time,
                        style: TextStyle(
                          fontSize: Responsive.font(context, 11),
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF64748B),
                  size: Responsive.w(context, 0.055),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}