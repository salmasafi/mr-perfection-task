// ملف أنماط النصوص - كل أحجام وأشكال الخطوط في مكان واحد
// بنستخدم static methods عشان نقدر نبعت الـ context ونحسب الحجم بشكل responsive
import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'app_colors.dart';

class AppTextStyles {
  // عنوان كبير - بيتستخدم في عناوين الشاشات الرئيسية
  static TextStyle titleLarge(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 22), // 22 بكسل على iPhone 13
        fontWeight: FontWeight.w700, // Bold
        color: AppColors.text,
      );

  // عنوان متوسط - بيتستخدم في عناوين الكروت والعناصر
  static TextStyle titleMedium(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 16),
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.text,
      );

  // نص صغير - بيتستخدم في الوصف والتفاصيل الثانوية
  static TextStyle bodySmall(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 12),
        color: AppColors.textSecondary, // رمادي
      );

  // نص للأزرار - أبيض عشان بيبقى فوق خلفية خضرا
  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 16),
        color: AppColors.onPrimary, // أبيض
        fontWeight: FontWeight.w600,
      );

  // نص كبير للجسم - بيتستخدم في العناوين الفرعية داخل الشاشة
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 14),
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      );

  // نص صغير جداً - للتفاصيل الدقيقة والـ hints
  static TextStyle caption(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 11),
        color: AppColors.textHint, // رمادي فاتح
        fontWeight: FontWeight.w400, // Regular
      );

  // نص الأزرار - بيتستخدم في الـ CustomButton
  static TextStyle button(BuildContext context) => TextStyle(
        fontFamily: 'Cairo',
        fontSize: Responsive.height(context, 15),
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary, // أبيض
        letterSpacing: 0.5, // مسافة بسيطة بين الحروف
      );
}
