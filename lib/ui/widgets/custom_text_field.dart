// ويدجت حقل الإدخال المخصص - بيستخدم في كل حقول الكتابة في التطبيق
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class CustomTextField extends StatelessWidget {
  final String hint; // النص اللي بيظهر لما الحقل فاضي
  final TextEditingController controller; // بيتحكم في قيمة الحقل
  final TextInputType keyboardType; // نوع الكيبورد (نص، أرقام، إيميل...)
  final int maxLines; // أقصى عدد سطور (1 = سطر واحد)
  final bool isRequired; // لو true بيضيف * جنب الـ hint
  final IconData? icon; // أيقونة على الشمال (اختياري)
  final bool obscureText; // لو true بيخفي النص (لكلمة المرور)

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text, // افتراضياً نص عادي
    this.maxLines = 1, // افتراضياً سطر واحد
    this.isRequired = false, // افتراضياً مش إجباري
    this.icon,
    this.obscureText = false, // افتراضياً النص ظاهر
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText, // بيخفي النص لو true (كلمة المرور)
      cursorColor: AppColors.primary, // لون المؤشر أخضر
      decoration: InputDecoration(
        // لو إجباري بنضيف * في الآخر
        hintText: isRequired ? '$hint *' : hint,
        hintStyle: TextStyle(
          color: AppColors.textHint, // رمادي فاتح
          fontSize: Responsive.height(context, 14),
        ),
        // بنعرض الأيقونة بس لو موجودة
        prefixIcon: icon != null
            ? Icon(icon,
                color: AppColors.grey, size: Responsive.width(context, 20))
            : null,
        filled: true, // خلفية مملوءة
        fillColor: AppColors.greyLight, // خلفية رمادية فاتحة
        // حدود عادية من غير خط
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
          borderSide: BorderSide.none, // من غير حدود
        ),
        // لما الحقل يتفوكس بنضيف حدود خضرا
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5), // حدود خضرا
        ),
        // مسافة داخلية
        contentPadding: EdgeInsets.symmetric(
          horizontal: Responsive.width(context, 16),
          vertical: Responsive.height(context, 16),
        ),
      ),
    );
  }
}
