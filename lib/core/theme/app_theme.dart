import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

ThemeData buildAppTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.card,
      onSurface: AppColors.text,
      outline: AppColors.greyMedium,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge(context),
      titleMedium: AppTextStyles.titleMedium(context),
      bodySmall: AppTextStyles.bodySmall(context),
      bodyLarge: AppTextStyles.bodyLarge(context),
      labelMedium: AppTextStyles.labelMedium(context),
    ),
    iconTheme: const IconThemeData(color: AppColors.icon),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      iconTheme: IconThemeData(color: AppColors.icon),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
  );
}
