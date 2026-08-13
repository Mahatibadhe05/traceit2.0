import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class AppRadius {
  AppRadius._();

  static double sm(BuildContext context) =>
      Responsive.radius(context, 8);

  static double md(BuildContext context) =>
      Responsive.radius(context, 12);

  static double lg(BuildContext context) =>
      Responsive.radius(context, 18);

  static double xl(BuildContext context) =>
      Responsive.radius(context, 24);
}