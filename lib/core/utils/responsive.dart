import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double w(BuildContext context, double value) =>
      screenWidth(context) * value;

  static double h(BuildContext context, double value) =>
      screenHeight(context) * value;

  // Responsive font based on shortest side
  static double font(BuildContext context, double size) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide * (size / 100);
  }

  static double radius(BuildContext context, double value) =>
      value * (screenWidth(context) / 390);
}