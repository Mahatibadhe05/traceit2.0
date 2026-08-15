import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'alert_details_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _selectedFilter = 'All Alerts';

  // ==========================================================
  // FIRESTORE ALERT STREAM
  // ==========================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> _alertsStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ==========================================================
  // CONVERT FIRESTORE DOCUMENT TO ALERT DATA
  // ==========================================================

  _AlertData _alertFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    final type = data['type']?.toString() ?? 'UNKNOWN';
    final title = data['title']?.toString() ?? 'Alert';
    final device =
        data['deviceId']?.toString() ?? 'Unknown Device';
    final message = data['message']?.toString() ?? '';

    Timestamp? timestamp;

    if (data['timestamp'] is Timestamp) {
      timestamp = data['timestamp'] as Timestamp;
    }

    return _AlertData(
      id: document.id,
      type: _displayType(type),
      firestoreType: type,
      title: title,
      device: _deviceName(device),
      time: _formatTime(timestamp),
      message: message,
      icon: _getIcon(type),
      iconColor: _getIconColor(type),
      backgroundColor: _getBackgroundColor(type),
    );
  }

  // ==========================================================
  // TYPE DISPLAY
  // ==========================================================

  String _displayType(String type) {
    switch (type) {
      case 'MOVING_AWAY':
        return 'Moving Away';

      case 'LEFT_BEHIND':
        return 'Left Behind';

      case 'CONNECTION_LOST':
        return 'Connection Lost';

      case 'LOW_BATTERY':
        return 'Low Battery';

      case 'ANTI_THEFT':
        return 'Anti-Theft';

      default:
        return type
            .replaceAll('_', ' ')
            .toLowerCase()
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? ''
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  // ==========================================================
  // DEVICE NAME
  // ==========================================================

  String _deviceName(String deviceId) {
    switch (deviceId) {
      case 'backpack_01':
        return 'Backpack';

      case 'keys_01':
        return 'Keys';

      case 'wallet_01':
        return 'Wallet';

      case 'glasses_01':
        return 'Glasses';

      default:
        return deviceId;
    }
  }

  // ==========================================================
  // TIME FORMAT
  // ==========================================================

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown time';
    }

    final difference =
        DateTime.now().difference(timestamp.toDate());

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;

      return '$minutes '
          '${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;

      return '$hours '
          '${hours == 1 ? 'hour' : 'hours'} ago';
    }

    final days = difference.inDays;

    if (days == 1) {
      return '1 day ago';
    }

    return '$days days ago';
  }

  // ==========================================================
  // ICON
  // ==========================================================

  IconData _getIcon(String type) {
    switch (type) {
      case 'MOVING_AWAY':
        return Icons.directions_walk;

      case 'LEFT_BEHIND':
        return Icons.key;

      case 'CONNECTION_LOST':
        return Icons.bluetooth_disabled;

      case 'LOW_BATTERY':
        return Icons.battery_alert;

      case 'ANTI_THEFT':
        return Icons.security;

      default:
        return Icons.notifications;
    }
  }

  // ==========================================================
  // ICON COLOR
  // ==========================================================

  Color _getIconColor(String type) {
    switch (type) {
      case 'MOVING_AWAY':
        return const Color(0xFFFF4D55);

      case 'LEFT_BEHIND':
        return const Color(0xFFFFAA18);

      case 'CONNECTION_LOST':
        return const Color(0xFFFF5B61);

      case 'LOW_BATTERY':
        return const Color(0xFF168FC5);

      case 'ANTI_THEFT':
        return const Color(0xFFFF4D55);

      default:
        return const Color(0xFF6C63FF);
    }
  }

  // ==========================================================
  // BACKGROUND COLOR
  // ==========================================================

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'MOVING_AWAY':
        return const Color(0xFFFFE8E8);

      case 'LEFT_BEHIND':
        return const Color(0xFFFFF3DF);

      case 'CONNECTION_LOST':
        return const Color(0xFFFFE8E8);

      case 'LOW_BATTERY':
        return const Color(0xFFE3F5FB);

      case 'ANTI_THEFT':
        return const Color(0xFFFFE8E8);

      default:
        return const Color(0xFFEDEBFF);
    }
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
      'Anti-Theft',
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                                    ? Icons
                                        .radio_button_checked
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
                                    color: const Color(
                                      0xFF263247,
                                    ),
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
  // OPEN ALERT DETAILS
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

            // FIX:
            // AlertDetailsScreen requires this parameter.
            backgroundColor: alert.backgroundColor,
          );
        },
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final horizontalPadding =
        width < 600 ? 22.0 : 32.0;

    final titleSize =
        width < 600 ? 28.0 : 34.0;

    final sectionSize =
        width < 600 ? 20.0 : 24.0;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

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
                      overflow:
                          TextOverflow.ellipsis,
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
            // FIRESTORE DATA
            // ==================================================

            Expanded(
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: _alertsStream(),

                builder: (context, snapshot) {
                  // ==================================================
                  // LOADING
                  // ==================================================

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                      ),
                    );
                  }

                  // ==================================================
                  // ERROR
                  // ==================================================

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 50,
                              color:
                                  Color(0xFFFF5B61),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            const Text(
                              'Unable to load alerts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    Color(0xFF263247),
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              '${snapshot.error}',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  const TextStyle(
                                fontSize: 13,
                                color:
                                    Color(0xFF8495AE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // CHECK LOGIN
                  // ==================================================

                  final user =
                      FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    return const Center(
                      child: _EmptyAlerts(
                        title: 'Not logged in',
                        subtitle:
                            'Please log in to view your alerts.',
                      ),
                    );
                  }

                  // ==================================================
                  // FIRESTORE DOCUMENTS
                  // ==================================================

                  final allAlerts =
                      snapshot.data?.docs
                              .map(
                                _alertFromFirestore,
                              )
                              .toList() ??
                          [];

                  // ==================================================
                  // APPLY FILTER
                  // ==================================================

                  final alerts =
                      _selectedFilter ==
                              'All Alerts'
                          ? allAlerts
                          : allAlerts
                              .where(
                                (alert) =>
                                    alert.type ==
                                    _selectedFilter,
                              )
                              .toList();

                  // ==================================================
                  // ALERT LIST
                  // ==================================================

                  return ListView(
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
                                fontSize:
                                    sectionSize,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    const Color(
                                  0xFF263247,
                                ),
                              ),
                            ),
                          ),

                          if (_selectedFilter !=
                              'All Alerts')
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
                                  color:
                                      Color(0xFF6C63FF),
                                  fontWeight:
                                      FontWeight.w600,
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
                          final alert =
                              alerts[index];

                          return Padding(
                            padding:
                                EdgeInsets.only(
                              bottom:
                                  index ==
                                          alerts.length -
                                              1
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
                  );
                },
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
  final String id;
  final String type;
  final String firestoreType;
  final String title;
  final String device;
  final String time;
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _AlertData({
    required this.id,
    required this.type,
    required this.firestoreType,
    required this.title,
    required this.device,
    required this.time,
    required this.message,
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
    final width =
        MediaQuery.of(context).size.width;

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
      borderRadius:
          BorderRadius.circular(20),
      elevation: 1,
      shadowColor: Colors.black12,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: onTap,

        child: Padding(
          padding:
              EdgeInsets.all(cardPadding),

          child: Row(
            children: [
              Container(
                width: iconBoxSize,
                height: iconBoxSize,

                decoration: BoxDecoration(
                  color:
                      alert.backgroundColor,
                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Icon(
                  alert.icon,
                  color: alert.iconColor,
                  size:
                      width < 600 ? 25 : 30,
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
                            const Color(
                          0xFF263247,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      alert.device,
                      style: TextStyle(
                        fontSize: deviceSize,
                        color:
                            const Color(
                          0xFF8495AE,
                        ),
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
                color:
                    Color(0xFF71829A),
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
  final String title;
  final String subtitle;

  const _EmptyAlerts({
    this.title = 'No alerts found',
    this.subtitle =
        'There are no alerts in this category.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 20,
      ),

      child: Column(
        children: [
          const Icon(
            Icons.notifications_none,
            size: 50,
            color:
                Color(0xFF9AA9BD),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF263247),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color:
                  Color(0xFF8495AE),
            ),
          ),
        ],
      ),
    );
  }
}