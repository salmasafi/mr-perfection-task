// ويدجت الحالة الفارغة - بيتعرض لما مفيش بيانات (مثلاً مفيش تبرعات)
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/custom_button.dart';

class EmptyStateView extends StatelessWidget {
  final String title; // العنوان الرئيسي
  final String subtitle; // النص التوضيحي
  final String buttonText; // نص الزر
  final IconData icon; // الأيقونة (افتراضياً أيقونة صندوق)
  final VoidCallback onActionPressed; // الفعل لما يضغط الزر

  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.icon = Icons.inventory_2_outlined, // افتراضياً أيقونة صندوق
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Responsive.width(context, 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // دايرة رمادية فيها الأيقونة
            Container(
              padding: EdgeInsets.all(Responsive.width(context, 32)),
              decoration: BoxDecoration(
                color: AppColors.greyLight, // خلفية رمادية فاتحة
                shape: BoxShape.circle, // شكل دائري
              ),
              child: Icon(
                icon,
                size: Responsive.width(context, 80),
                color: AppColors.greyMedium, // رمادي متوسط
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // العنوان الرئيسي
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: Responsive.height(context, 18),
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.height(context, 8)),

            // النص التوضيحي
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: Responsive.height(context, 14),
                color: AppColors.textSecondary, // رمادي
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.height(context, 40)),

            // زر الإجراء (مثلاً "أضف تبرع جديد")
            CustomButton(
              text: buttonText,
              icon: Icons.add,
              onPressed: onActionPressed,
            ),
          ],
        ),
      ),
    );
  }
}
