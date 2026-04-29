// شاشة تفاصيل التبرع - بتعرض كل معلومات التبرع وزر الطلب
import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/models/product_model.dart';
import '../widgets/free_badge.dart';
import '../widgets/app_network_image.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel; // بيانات التبرع اللي هيتعرض

  const ProductDetailsScreen(this.productModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== قسم الصورة ==========
            SizedBox(
              height: Responsive.height(context, 400), // ارتفاع ثابت للصورة
              child: Stack(
                children: [
                  // صورة التبرع بتملأ كل المساحة
                  AppNetworkImage(
                    imageUrl: productModel.image,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 30, // حواف دايرية في الأسفل
                  ),

                  // زر الرجوع في الركن العلوي الأيسر
                  Positioned(
                    top: Responsive.height(context, 50),
                    left: Responsive.width(context, 16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // بنرجع للشاشة السابقة
                      child: Container(
                        padding: EdgeInsets.all(Responsive.width(context, 10)),
                        decoration: BoxDecoration(
                          color: Colors.white, // خلفية بيضا
                          shape: BoxShape.circle, // شكل دايري
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: AppColors.primary), // سهم للأمام (RTL)
                      ),
                    ),
                  ),

                  // بادج "مجاني" في الركن العلوي الأيمن
                  Positioned(
                    top: Responsive.height(context, 50),
                    right: Responsive.width(context, 16),
                    child: FreeBadge(
                      fontSize: Responsive.height(context, 13), // حجم أكبر شوية
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 16),
                        vertical: Responsive.height(context, 6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ========== قسم المحتوى ==========
            Padding(
              padding: EdgeInsets.all(Responsive.width(context, 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.height(context, 8)),

                  // اسم التبرع
                  Text(
                    productModel.title,
                    style: AppTextStyles.titleLarge(context),
                  ),
                  SizedBox(height: Responsive.height(context, 12)),

                  // عنوان قسم الوصف
                  Text(
                    'الوصف',
                    style: AppTextStyles.bodyLarge(context),
                  ),
                  SizedBox(height: Responsive.height(context, 8)),

                  // نص الوصف
                  Text(
                    productModel.description,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      height: 1.6, // مسافة بين السطور عشان يبقى مريح للقراءة
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 32)),

                  // ========== زر طلب التبرع ==========
                  GestureDetector(
                    onTap: () {
                      // بنروح لشاشة تأكيد الطلب
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CheckoutScreen(product: productModel),
                        ),
                      );
                    },
                    child: Container(
                      height: Responsive.height(context, 56),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary, // خلفية خضرا
                        borderRadius: BorderRadius.circular(
                            Responsive.width(context, 40)), // حواف دايرية كتير
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3), // ظل أخضر شفاف
                            blurRadius: 12,
                            offset: const Offset(0, 6), // الظل تحت الزر
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline,
                              color: Colors.white,
                              size: Responsive.width(context, 22)),
                          SizedBox(width: Responsive.width(context, 8)),
                          Text(
                            'اطلب هذا التبرع',
                            style: AppTextStyles.labelMedium(context), // نص أبيض
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
