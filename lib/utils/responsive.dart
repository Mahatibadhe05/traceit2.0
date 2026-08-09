import 'dart:math' as math;
import 'package:flutter/material.dart';

class Responsive {
  static const double baseWidth = 390;
  static const double baseHeight = 844;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Use values like 0.05 for 5% of screen width.
  static double w(BuildContext context, double value) {
    final width = math.min(
      screenWidth(context),
      430,
    );

    return width * value;
  }

  // Use values like 0.03 for 3% of screen height.
  static double h(BuildContext context, double value) {
    final height = math.min(
      screenHeight(context),
      932,
    );

    return height * value;
  }

  // Responsive font scaling.
  static double font(BuildContext context, double value) {
    final shortestSide =
        MediaQuery.of(context).size.shortestSide;

    final scale = math.min(
      shortestSide,
      baseWidth,
    );

    return scale * (value / 100);
  }

  // Radius uses pixel-like values.
  // Example: Responsive.radius(context, 14)
  static double radius(BuildContext context, double value) {
    final width = screenWidth(context);

    final scale = math.min(
      width / baseWidth,
      1.1,
    );

    return value * scale;
  }
}