import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/responsive.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Main screen titles
  static TextStyle heading(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: Responsive.font(context, 6),
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  // Section titles
  static TextStyle sectionTitle(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: Responsive.font(context, 4),
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  // Normal body text
  static TextStyle body(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: Responsive.font(context, 3.5),
      color: AppColors.textPrimary,
    );
  }

  // Subtitle / hint text
  static TextStyle subtitle(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: Responsive.font(context, 3.3),
      color: AppColors.textSecondary,
    );
  }

  // Button text
  static TextStyle button(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: Responsive.font(context, 3.8),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}