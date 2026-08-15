import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../utils/responsive.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.h(context, 0.12),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(context, 0.05),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(
          Responsive.radius(context, 18),
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: Responsive.w(context, 0.045),
            backgroundColor: color.withValues(alpha: 0.10),
            child: Icon(
              icon,
              color: color,
              size: Responsive.w(context, 0.05),
            ),
          ),

          SizedBox(
            width: Responsive.w(context, 0.03),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.heading(context).copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
