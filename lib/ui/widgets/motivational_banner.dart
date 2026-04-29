// ويدجت البانر التحفيزي - بيتعرض في شاشة إضافة التبرع عشان يشجع المستخدم
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class MotivationalBanner extends StatelessWidget {
  final String text; // النص التحفيزي
  final String emoji; // الإيموجي (افتراضياً قلب أخضر)

  const MotivationalBanner({
    super.key,
    required this.text,
    this.emoji = '💚', // افتراضياً قلب أخضر
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // بياخد كل العرض
      padding: EdgeInsets.all(Responsive.width(context, 16)),
      decoration: BoxDecoration(
        color: AppColors.greyLight, // خلفية رمادية فاتحة
        borderRadius: BorderRadius.circular(Responsive.width(context, 16)),
      ),
      child: Row(
        children: [
          // الإيموجي على اليمين
          Text(
            emoji,
            style: TextStyle(fontSize: Responsive.height(context, 24)),
          ),
          SizedBox(width: Responsive.width(context, 12)),
          // النص التحفيزي - Expanded عشان ياخد باقي المساحة
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: Responsive.height(context, 13),
                color: AppColors.textSecondary, // رمادي
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
