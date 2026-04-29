// ويدجت كارت التبرع - بيعرض معلومات تبرع واحد في الـ Grid
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import '../screens/product_details.dart';
import '../screens/checkout_screen.dart';
import 'free_badge.dart';
import 'app_network_image.dart';
import 'favorite_button.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel; // بيانات التبرع

  const ProductCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // لما يضغط على الكارت يروح لشاشة التفاصيل
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productModel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card, // خلفية بيضا
          borderRadius: BorderRadius.circular(Responsive.width(context, 20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow, // ظل خفيف
              spreadRadius: 0,
              blurRadius: Responsive.width(context, 15),
              offset: Offset(0, Responsive.height(context, 4)), // الظل تحت الكارت
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الجزء العلوي - الصورة (5 من أصل 8 أجزاء)
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // صورة التبرع
                  AppNetworkImage(
                    imageUrl: productModel.image,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: Responsive.width(context, 20),
                  ),
                  // بادج "مجاني" في الركن العلوي الأيمن
                  Positioned(
                    top: Responsive.height(context, 8),
                    right: Responsive.width(context, 8),
                    child: const FreeBadge(),
                  ),
                ],
              ),
            ),

            // الجزء السفلي - الاسم والزر (3 من أصل 8 أجزاء)
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(Responsive.width(context, 10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم التبرع
                    Text(
                      productModel.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1, // سطر واحد بس
                      overflow: TextOverflow.ellipsis, // لو طويل يحط ...
                    ),
                    const Spacer(), // بيدفع الزر لأسفل

                    // زر الطلب على اليسار
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FavoriteButton(
                          // لما يضغط الزر يروح لشاشة الطلب
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutScreen(product: productModel),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
