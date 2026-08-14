import 'package:flutter/material.dart';
import 'alert_details_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All Alerts';

  final List<_AlertData> _alerts = const [
    _AlertData(
      type: 'Moving Away',
      title: 'Moving Away Alert',
      device: 'Backpack',
      time: '2 min ago',
      icon: Icons.directions_walk,
      iconColor: Color(0xFFFF4D55),
      backgroundColor: Color(0xFFFFE8E8),
    ),
    _AlertData(
      type: 'Left Behind',
      title: 'Left Behind Alert',
      device: 'Keys',
      time: '1 hour ago',
      icon: Icons.key,
      iconColor: Color(0xFFFFAA18),
      backgroundColor: Color(0xFFFFF3DF),
    ),
    _AlertData(
      type: 'Connection Lost',
      title: 'Connection Lost',
      device: 'Wallet',
      time: '3 hours ago',
      icon: Icons.bluetooth_disabled,
      iconColor: Color(0xFFFF5B61),
      backgroundColor: Color(0xFFFFE8E8),
    ),
    _AlertData(
      type: 'Low Battery',
      title: 'Low Battery Alert',
      device: 'Glasses',
      time: '1 day ago',
      icon: Icons.battery_alert,
      iconColor: Color(0xFF168FC5),
      backgroundColor: Color(0xFFE3F5FB),
    ),
  ];

  List<_AlertData> get _filteredAlerts {
    if (_selectedFilter == 'All Alerts') {
      return _alerts;
    }

    return _alerts
        .where((alert) => alert.type == _selectedFilter)
        .toList();
  }

  // ==========================================================
  // OPEN DETAILS SCREEN
  // ==========================================================

  void _openAlert(_AlertData alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AlertDetailsScreen(
            title: alert.title,
            device: alert.device,
            time: alert.time,
            icon: alert.icon,
            iconColor: alert.iconColor,
            backgroundColor: alert.backgroundColor,
          );
        },
      ),
    );
  }

  // ==========================================================
  // FILTER MENU
  // ==========================================================

  void _showFilterMenu() {
    const filters = [
      'All Alerts',
      'Moving Away',
      'Left Behind',
      'Connection Lost',
      'Low Battery',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Alerts',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263247),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Select an alert category',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8495AE),
                  ),
                ),

                const SizedBox(height: 12),

                ...filters.map(
                  (filter) {
                    final isSelected =
                        filter == _selectedFilter;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(14),
                        onTap: () {
                          Navigator.pop(sheetContext);

                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? const Color(0xFF6C63FF)
                                    : const Color(0xFF8A97AA),
                                size: 24,
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color:
                                        const Color(0xFF263247),
                                  ),
                                ),
                              ),

                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF6C63FF),
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      ),
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

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final horizontalPadding =
        width < 600 ? 22.0 : 32.0;

    final titleSize =
        width < 600 ? 28.0 : 34.0;

    final sectionSize =
        width < 600 ? 20.0 : 24.0;

    final alerts = _filteredAlerts;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                14,
              ),
              child: Row(
                children: [
                  Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  const Spacer(),

                  TextButton.icon(
                    onPressed: _showFilterMenu,

                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      size: 22,
                      color: Color(0xFF6C63FF),
                    ),

                    label: Text(
                      _selectedFilter == 'All Alerts'
                          ? 'Filter'
                          : _selectedFilter,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // ALERT LIST
            // ==================================================

            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  22,
                  horizontalPadding,
                  30,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFilter,
                          style: TextStyle(
                            fontSize: sectionSize,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF263247),
                          ),
                        ),
                      ),

                      if (_selectedFilter != 'All Alerts')
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedFilter =
                                  'All Alerts';
                            });
                          },
                          child: const Text(
                            'Show All',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (alerts.isEmpty)
                    const _EmptyAlerts(),

                  ...List.generate(
                    alerts.length,
                    (index) {
                      final alert = alerts[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index == alerts.length - 1
                                  ? 0
                                  : 16,
                        ),
                        child: _AlertCard(
                          alert: alert,
                          onTap: () {
                            _openAlert(alert);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ALERT DATA
// ==========================================================

class _AlertData {
  final String type;
  final String title;
  final String device;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _AlertData({
    required this.type,
    required this.title,
    required this.device,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}

// ==========================================================
// ALERT CARD
// ==========================================================

class _AlertCard extends StatelessWidget {
  final _AlertData alert;
  final VoidCallback onTap;

  const _AlertCard({
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final cardPadding =
        width < 600 ? 14.0 : 20.0;

    final iconBoxSize =
        width < 600 ? 54.0 : 64.0;

    final titleSize =
        width < 600 ? 16.0 : 19.0;

    final deviceSize =
        width < 600 ? 14.0 : 16.0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 1,
      shadowColor: Colors.black12,

      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,

        child: Padding(
          padding: EdgeInsets.all(cardPadding),

          child: Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,

                decoration: BoxDecoration(
                  color: alert.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(
                  alert.icon,
                  color: alert.iconColor,
                  size: width < 600 ? 25 : 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            const Color(0xFF263247),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      alert.device,
                      style: TextStyle(
                        fontSize: deviceSize,
                        color:
                            const Color(0xFF8495AE),
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      alert.time,
                      style:
                          const TextStyle(
                        fontSize: 13,
                        color:
                            Color(0xFF9AA9BD),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                size: 28,
                color: Color(0xFF71829A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 50,
            color: Color(0xFF9AA9BD),
          ),

          SizedBox(height: 12),

          Text(
            'No alerts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF263247),
            ),
          ),

          SizedBox(height: 5),

          Text(
            'There are no alerts in this category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8495AE),
            ),
          ),
        ],
      ),
    );
  }
}