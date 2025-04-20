import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle titleLarge(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 20),
        fontWeight: FontWeight.bold,
      );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 16),
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 12),
        color: AppColors.grey,
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 16),
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 14),
        fontWeight: FontWeight.bold,
      );
}
