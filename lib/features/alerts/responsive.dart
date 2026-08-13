import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Percentage of screen width.
  // Example: Responsive.w(context, 0.05) = 5% of screen width.
  static double w(BuildContext context, double value) {
    return width(context) * value;
  }

  // Percentage of screen height.
  // Example: Responsive.h(context, 0.03) = 3% of screen height.
  static double h(BuildContext context, double value) {
    return height(context) * value;
  }

  // Responsive font based on the shortest side.
  static double font(BuildContext context, double value) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return value * (shortestSide / 390);
  }

  // Radius based on a 390px reference width.
  // IMPORTANT: pass the intended radius, e.g. 14, NOT 0.035.
  static double radius(BuildContext context, double value) {
    return value * (width(context) / 390);
  }
}