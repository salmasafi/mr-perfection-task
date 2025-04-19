import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme(BuildContext context) {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        titleLarge: AppTextStyles.title(context),
        titleMedium: AppTextStyles.subtitle(context),
        bodySmall: AppTextStyles.bodySmall(context),
        bodyLarge: AppTextStyles.price(context),
      ),
      iconTheme: IconThemeData(color: AppColors.icon),
    );
  }
