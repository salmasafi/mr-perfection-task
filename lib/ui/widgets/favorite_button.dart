// ويدجت زر الطلب (القلب) - بيظهر في كل كارت تبرع عشان المستخدم يطلبه
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onTap; // الفعل لما يتضغط الزر
  final IconData icon; // الأيقونة (افتراضياً قلب)

  const FavoriteButton({
    super.key,
    required this.onTap,
    this.icon = Icons.favorite_outline, // افتراضياً قلب فاضي
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // لما يتضغط بينفذ الفعل المطلوب
      child: Container(
        padding: EdgeInsets.all(Responsive.width(context, 8)),
        decoration: BoxDecoration(
          color: AppColors.primary, // خلفية خضرا
          borderRadius:
              BorderRadius.circular(Responsive.width(context, 10)), // حواف دايرية
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3), // ظل أخضر شفاف
              blurRadius: 8,
              offset: const Offset(0, 4), // الظل تحت الزر
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white, // أيقونة بيضا
          size: Responsive.width(context, 18),
        ),
      ),
    );
  }
}
