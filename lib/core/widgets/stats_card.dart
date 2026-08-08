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
    return Expanded(
      child: Container(
        height: Responsive.h(context, 0.085),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, 0.04),
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(
            Responsive.radius(context, 16),
          ),
          border: Border.all(
            color: color.withOpacity(.15),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: Responsive.w(context, 0.045),
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
                size: Responsive.w(context, 0.05),
              ),
            ),

            SizedBox(width: Responsive.w(context, 0.03)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.heading(context).copyWith(
                      fontSize: Responsive.font(context, 0.04),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.subtitle(context).copyWith(
                      fontSize: Responsive.font(context, 0.028),
                    ),
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
