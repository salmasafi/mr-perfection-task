import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme(BuildContext context) {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        titleLarge: AppTextStyles.titleLarge(context),
        titleMedium: AppTextStyles.titleMedium(context),
        bodySmall: AppTextStyles.bodySmall(context),
        bodyLarge: AppTextStyles.bodyLarge(context),
        labelMedium:  AppTextStyles.labelMedium(context),
      ),
      iconTheme: IconThemeData(color: AppColors.icon),
    );
  }
