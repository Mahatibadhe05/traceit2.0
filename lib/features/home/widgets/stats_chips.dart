import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';
import '../../../core/widgets/stats_card.dart';

class StatsChips extends StatelessWidget {
  final int deviceCount;
  final int connectedCount;

  const StatsChips({
    super.key,
    required this.deviceCount,
    required this.connectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: "Device${deviceCount == 1 ? '' : 's'}",
            value: "$deviceCount",
            icon: Icons.devices,
            color: Colors.blue,
          ),
        ),
        SizedBox(
          width: Responsive.w(context, 0.025),
        ),
        Expanded(
          child: StatsCard(
            title: "Connected",
            value: "$connectedCount",
            icon: Icons.bluetooth_connected,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
