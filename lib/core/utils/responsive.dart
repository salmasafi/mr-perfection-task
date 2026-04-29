// ملف الـ Responsive - بيخلي التطبيق يبان كويس على كل الشاشات
import 'package:flutter/material.dart';

class Responsive {
  // بتحسب الارتفاع بالنسبة لشاشة iPhone 13 (812 بكسل)
  // مثلاً لو قلت height(context, 20) هيرجع 20 بكسل على iPhone 13
  // وعلى شاشة أصغر هيرجع أقل، وعلى أكبر هيرجع أكتر
  static double height(BuildContext context, double value) =>
      MediaQuery.of(context).size.height * (value / 812);

  // نفس الفكرة بس للعرض - مبني على عرض iPhone 13 (375 بكسل)
  static double width(BuildContext context, double value) =>
      MediaQuery.of(context).size.width * (value / 375);
}
