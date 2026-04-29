// ويدجت الزر المخصص - بيستخدم في كل أزرار التطبيق مع animation عند الضغط
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

// StatefulWidget عشان محتاجين نتحكم في الـ animation
class CustomButton extends StatefulWidget {
  final String text; // نص الزر
  final VoidCallback onPressed; // الفعل لما يتضغط
  final bool isOutlined; // لو true بيبقى زر بحدود بس من غير خلفية
  final IconData? icon; // أيقونة جنب النص (اختياري)

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false, // افتراضياً زر مملوء
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  // الـ AnimationController بيتحكم في الـ animation
  late AnimationController _controller;

  // الـ Animation بيحدد قيمة الـ scale (الحجم) في كل لحظة
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // بنعمل الـ controller بمدة 100 millisecond (سريع)
    _controller = AnimationController(
      vsync: this, // SingleTickerProviderStateMixin بيوفر الـ vsync
      duration: const Duration(milliseconds: 100),
    );

    // الزر بيتصغر من 1.0 لـ 0.96 لما يتضغط (تأثير الضغط)
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // لازم نتخلص من الـ controller عشان منحصلش memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(), // لما الإصبع ينزل: بنصغر الزر
      onTapUp: (_) {
        _controller.reverse(); // لما الإصبع يرفع: بنرجع الحجم الأصلي
        widget.onPressed(); // بننفذ الفعل المطلوب
      },
      onTapCancel: () => _controller.reverse(), // لو الضغط اتلغى نرجع الحجم
      child: AnimatedBuilder(
        animation: _scale,
        // بنطبق الـ scale على الزر في كل frame
        builder: (context, child) => Transform.scale(
          scale: _scale.value, // القيمة بتتغير من 1.0 لـ 0.96
          child: child,
        ),
        child: Container(
          width: double.infinity, // بياخد كل العرض المتاح
          height: Responsive.height(context, 56), // ارتفاع ثابت responsive
          decoration: BoxDecoration(
            // لو outlined خلفية شفافة، غير كده خضرا
            color: widget.isOutlined ? Colors.transparent : AppColors.primary,
            borderRadius: BorderRadius.circular(Responsive.width(context, 40)), // حواف دايرية كتير
            // لو outlined نضيف حدود خضرا
            border: widget.isOutlined
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // في النص
            children: [
              // بنعرض الأيقونة بس لو موجودة
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  // لو outlined الأيقونة خضرا، غير كده بيضا
                  color: widget.isOutlined ? AppColors.primary : Colors.white,
                  size: Responsive.width(context, 20),
                ),
                SizedBox(width: Responsive.width(context, 8)), // مسافة بين الأيقونة والنص
              ],
              Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  // لو outlined النص أخضر، غير كده أبيض
                  color: widget.isOutlined ? AppColors.primary : Colors.white,
                  fontSize: Responsive.height(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
