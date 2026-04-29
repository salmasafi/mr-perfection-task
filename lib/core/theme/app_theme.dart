// ملف الثيم الرئيسي - بيجمع كل إعدادات الشكل العام للتطبيق في مكان واحد
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

// دالة بترجع الـ ThemeData الكاملة للتطبيق
// بنبعتلها الـ context عشان نقدر نحسب الأحجام بشكل responsive
ThemeData buildAppTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true, // بنستخدم Material Design 3 (الأحدث)
    fontFamily: 'Cairo', // الخط الافتراضي لكل التطبيق
    primaryColor: AppColors.primary, // اللون الأساسي

    // لون خلفية كل الشاشات
    scaffoldBackgroundColor: AppColors.background,

    // نظام الألوان - بيحدد الألوان الأساسية والثانوية
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // اللون الأساسي (الأخضر)
      onPrimary: AppColors.onPrimary, // اللون فوق الأساسي (أبيض)
      surface: AppColors.card, // لون السطح (الكروت)
      onSurface: AppColors.text, // لون النص فوق السطح
      outline: AppColors.greyMedium, // لون الحدود
    ),

    // أنماط النصوص الافتراضية - بتتطبق على كل النصوص في التطبيق
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge(context), // عنوان كبير
      titleMedium: AppTextStyles.titleMedium(context), // عنوان متوسط
      bodySmall: AppTextStyles.bodySmall(context), // نص صغير
      bodyLarge: AppTextStyles.bodyLarge(context), // نص كبير
      labelMedium: AppTextStyles.labelMedium(context), // نص الأزرار
    ),

    // شكل الأيقونات الافتراضي
    iconTheme: const IconThemeData(color: AppColors.icon),

    // شكل الـ AppBar في كل الشاشات
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // خلفية شفافة
      elevation: 0, // من غير ظل
      centerTitle: true, // العنوان في النص
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      iconTheme: IconThemeData(color: AppColors.icon), // لون أيقونات الـ AppBar
    ),

    // شكل الكروت الافتراضي
    cardTheme: CardThemeData(
      color: AppColors.card, // خلفية بيضا
      elevation: 0, // من غير ظل افتراضي
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // حواف دايرية
      ),
    ),

    // شكل خط الفصل (Divider)
    dividerTheme: const DividerThemeData(
      color: AppColors.divider, // لون رمادي فاتح
      thickness: 1, // سماكة بكسل واحد
    ),
  );
}
