// ويدجت التحميل - بيتعرض لما البيانات بتتجلب من السيرفر
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class ProductsLoadingWidget extends StatelessWidget {
  const ProductsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(context, 500), // ارتفاع كبير عشان يبقى في النص
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary, // دايرة خضرا
          strokeWidth: 2, // رفيعة شوية
        ),
      ),
    );
  }
}
