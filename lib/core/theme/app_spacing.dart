import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class AppSpacing {
  AppSpacing._();

  static double xs(BuildContext context) => Responsive.h(context, 0.008);

  static double sm(BuildContext context) => Responsive.h(context, 0.015);

  static double md(BuildContext context) => Responsive.h(context, 0.025);

  static double lg(BuildContext context) => Responsive.h(context, 0.04);

  static double xl(BuildContext context) => Responsive.h(context, 0.06);
}