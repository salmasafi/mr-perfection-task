// ويدجت الديالوج - بيعرض نوافذ تأكيد ورسائل موحدة في كل التطبيق
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppDialog extends StatelessWidget {
  final String title; // عنوان الديالوج
  final String content; // محتوى الرسالة
  final String confirmText; // نص زر التأكيد
  final VoidCallback onConfirm; // الفعل لما يضغط تأكيد
  final String? cancelText; // نص زر الإلغاء (اختياري)
  final VoidCallback? onCancel; // الفعل لما يضغط إلغاء (اختياري)
  final bool isDestructive; // لو true الزر بيبقى أحمر (للحذف مثلاً)

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'حسناً', // افتراضياً "حسناً"
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.isDestructive = false, // افتراضياً مش destructive
  });

  // ========== طريقة عرض ديالوج عادي (للنجاح والمعلومات) ==========
  // static عشان نقدر ننادي عليها من غير ما نعمل instance
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'حسناً',
    required VoidCallback onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
        cancelText: cancelText,
        // لو مفيش onCancel نعمل واحد افتراضي يقفل الديالوج
        onCancel: onCancel ?? () => Navigator.pop(dialogContext),
        isDestructive: isDestructive,
      ),
    );
  }

  // ========== طريقة عرض ديالوج تأكيد (بيرجع true أو false) ==========
  // بنستخدمه لما نحتاج نعرف المستخدم ضغط تأكيد ولا إلغاء
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: const TextStyle(
              fontFamily: 'Cairo', color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        actions: [
          // زر الإلغاء - بيرجع false
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              cancelText,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.textSecondary),
            ),
          ),
          // زر التأكيد - بيرجع true
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              confirmText,
              style: TextStyle(
                fontFamily: 'Cairo',
                // لو destructive اللون أحمر، غير كده أخضر
                color: isDestructive ? Colors.red : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== بناء الـ Widget ==========
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // العنوان
      title: Text(
        title,
        style:
            const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      // المحتوى
      content: Text(
        content,
        style: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
          height: 1.5, // مسافة بين السطور
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        // زر الإلغاء - بيظهر بس لو cancelText موجود
        if (cancelText != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: Text(
              cancelText!,
              style: const TextStyle(
                  fontFamily: 'Cairo', color: AppColors.textSecondary),
            ),
          ),
        // زر التأكيد - دايماً موجود
        Center(
          child: TextButton(
            onPressed: onConfirm,
            child: Text(
              confirmText,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: isDestructive ? Colors.red : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
