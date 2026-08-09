import 'dart:math' as math;
import 'package:flutter/material.dart';

class Responsive {
  // Reference dimensions for a typical mobile screen.
  static const double maxWidth = 430;
  static const double maxHeight = 932;

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double w(BuildContext context, double value) {
    final width = math.min(
      screenWidth(context),
      maxWidth,
    );

    return width * value;
  }

  static double h(BuildContext context, double value) {
    final height = math.min(
      screenHeight(context),
      maxHeight,
    );

    return height * value;
  }

  static double font(BuildContext context, double value) {
    final shortestSide =
        MediaQuery.of(context).size.shortestSide;

    final responsiveSide = math.min(
      shortestSide,
      maxWidth,
    );

    return responsiveSide * (value / 100);
  }

  static double radius(BuildContext context, double value) {
    final width = math.min(
      screenWidth(context),
      maxWidth,
    );

    return width * value;
  }
}