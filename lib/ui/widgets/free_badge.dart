// ويدجت الـ Badge "مجاني" - بيتعرض فوق كل تبرع عشان يوضح إنه مجاني
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class FreeBadge extends StatelessWidget {
  final double? fontSize; // حجم الخط (اختياري - عشان يتغير حسب المكان)
  final EdgeInsetsGeometry? padding; // المسافة الداخلية (اختياري)

  const FreeBadge({
    super.key,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // لو مفيش padding محدد نستخدم الافتراضي
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 10),
            vertical: Responsive.height(context, 3),
          ),
      decoration: BoxDecoration(
        color: AppColors.primary, // خلفية خضرا
        borderRadius:
            BorderRadius.circular(Responsive.width(context, 20)), // حواف دايرية كتير
      ),
      child: Text(
        'مجاني',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.onPrimary, // نص أبيض
          // لو مفيش fontSize محدد نستخدم الافتراضي
          fontSize: fontSize ?? Responsive.height(context, 10),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
