import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle titleLarge(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 22),
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      );

  static TextStyle titleMedium(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 16),
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 12),
        color: AppColors.textSecondary,
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 16),
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 14),
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 11),
        color: AppColors.textHint,
        fontWeight: FontWeight.w400,
      );

  static TextStyle button(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 15),
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
        letterSpacing: 0.5,
      );
}
