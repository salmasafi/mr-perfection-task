// ويدجت الخطأ - بيتعرض لما حصل مشكلة في جلب البيانات مع زر "حاول مجدداً"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/products_cubit.dart';

class ProductsErrorWidget extends StatelessWidget {
  final String message; // رسالة الخطأ اللي هتتعرض للمستخدم

  const ProductsErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Responsive.height(context, 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الخطأ
            Icon(
              Icons.error_outline,
              size: Responsive.width(context, 60),
              color: AppColors.grey,
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // رسالة الخطأ
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.height(context, 20)),

            // زر "حاول مجدداً" - لما يتضغط بيعيد جلب المنتجات
            GestureDetector(
              onTap: () {
                // بنوصل للـ Cubit ونطلب منه يجيب المنتجات تاني
                context.read<ProductsCubit>().fetchProducts();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.width(context, 32),
                  vertical: Responsive.height(context, 14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary, // خلفية خضرا
                  borderRadius:
                      BorderRadius.circular(Responsive.width(context, 15)),
                ),
                child: Text(
                  'حاول مجدداً',
                  style: Theme.of(context).textTheme.labelMedium, // نص أبيض
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
