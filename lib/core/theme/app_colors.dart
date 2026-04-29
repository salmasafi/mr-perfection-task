// ملف الألوان - كل الألوان اللي بنستخدمها في التطبيق في مكان واحد
// عشان لو عايزين نغير لون نغيره هنا بس وكل التطبيق يتغير
import 'package:flutter/material.dart';

class AppColors {
  // اللون الأساسي للتطبيق - الأخضر الزمردي
  static const primary = Color(0xFF059669); // أخضر زمردي غامق
  static const onPrimary = Colors.white; // اللون فوق الأخضر (الكتابة البيضا)

  // ألوان الخلفية
  static const background = Color(0xFFF8F9FA); // أبيض شوية رمادي - خلفية الشاشات
  static const card = Colors.white; // لون الكروت والعناصر

  // ألوان النصوص
  static const text = Color(0xFF1A1F1C); // أسود مايل للأخضر - للعناوين
  static const textSecondary = Color(0xFF64748B); // رمادي - للنصوص الثانوية
  static const textHint = Color(0xFF94A3B8); // رمادي فاتح - للـ placeholder

  // درجات الرمادي
  static const grey = Color(0xFF94A3B8); // رمادي عادي
  static final greyLight = const Color(0xFFF1F5F9); // رمادي فاتح جداً - للخلفيات
  static const greyMedium = Color(0xFFE2E8F0); // رمادي متوسط - للحدود
  static const greyDark = Color(0xFF475569); // رمادي غامق

  // ألوان وظيفية
  static const divider = Color(0xFFE2E8F0); // لون الخط الفاصل
  static const shadow = Color(0x0A000000); // ظل خفيف جداً (شفافية 4%)
  static const shadowMedium = Color(0x14000000); // ظل متوسط (شفافية 8%)

  // ألوان الأيقونات
  static const icon = Color(0xFF1A1F1C); // لون الأيقونات الأساسية
  static const iconLight = Color(0xFF94A3B8); // لون الأيقونات الثانوية
}
