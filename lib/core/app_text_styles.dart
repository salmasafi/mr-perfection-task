import 'package:flutter/material.dart';
import 'responsive.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 20),
        fontWeight: FontWeight.bold,
      );

  static TextStyle subtitle(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 16),
        fontWeight: FontWeight.w600,
      );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 12),
        color: AppColors.grey,
      );

  static TextStyle price(BuildContext context) => TextStyle(
        fontSize: Responsive.height(context, 14),
        fontWeight: FontWeight.bold,
      );
}
