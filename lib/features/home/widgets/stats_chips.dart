import 'package:flutter/material.dart';

import '../../../core/utils/responsive.dart';

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
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Responsive.h(context, 0.013),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.devices,
                  size: 18,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  "$deviceCount Device${deviceCount == 1 ? '' : 's'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Responsive.h(context, 0.013),
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.bluetooth_connected,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 6),
                Text(
                  "$connectedCount Connected",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
