// ويدجت الـ Snackbar - بيعرض رسائل سريعة في أسفل الشاشة
// موحد عشان كل الرسائل تبقى بنفس الشكل في كل التطبيق
import 'package:flutter/material.dart';

class AppSnackbar {
  // ========== رسالة خطأ (حمرا) ==========
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.red.shade400, // خلفية حمرا
        behavior: SnackBarBehavior.floating, // بتطفو فوق المحتوى
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)), // حواف دايرية
      ),
    );
  }

  // ========== رسالة نجاح (خضرا) ==========
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.green.shade600, // خلفية خضرا
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
