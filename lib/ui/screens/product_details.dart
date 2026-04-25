import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../../logic/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  const ProductDetailsScreen(this.productModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: Responsive.height(context, 400),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      productModel.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.greyLight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: Responsive.width(context, 80),
                                color: AppColors.grey,
                              ),
                              SizedBox(
                                  height: Responsive.height(context, 16)),
                              Text(
                                'لا توجد صورة',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: Responsive.width(context, 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColors.greyLight,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress
                                              .cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Back button
                  Positioned(
                    top: Responsive.height(context, 50),
                    left: Responsive.width(context, 16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.width(context, 10)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                  // Free badge
                  Positioned(
                    top: Responsive.height(context, 50),
                    right: Responsive.width(context, 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 16),
                        vertical: Responsive.height(context, 6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                            Responsive.width(context, 20)),
                      ),
                      child: Text(
                        'مجاني',
                        style: TextStyle(fontFamily: 'Cairo', 
                          color: AppColors.onPrimary,
                          fontSize: Responsive.height(context, 13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(Responsive.width(context, 20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.height(context, 8)),
                  Text(
                    productModel.title,
                    style: AppTextStyles.titleLarge(context),
                  ),
                  SizedBox(height: Responsive.height(context, 12)),

                  // Donor & condition info
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.person_outline,
                        text: productModel.donorName,
                      ),
                      SizedBox(width: Responsive.width(context, 12)),
                      _InfoChip(
                        icon: Icons.verified_outlined,
                        text: productModel.condition,
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.height(context, 8)),

                  // Category & availability
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.category_outlined,
                        text: productModel.category,
                      ),
                      SizedBox(width: Responsive.width(context, 12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(context, 10),
                          vertical: Responsive.height(context, 4),
                        ),
                        decoration: BoxDecoration(
                          color: productModel.isAvailable
                              ? AppColors.primary
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(
                              Responsive.width(context, 8)),
                        ),
                        child: Text(
                          productModel.isAvailable ? 'متاح' : 'محجوز',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.height(context, 11),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.height(context, 20)),

                  // Description
                  Text(
                    'الوصف',
                    style: AppTextStyles.bodyLarge(context),
                  ),
                  SizedBox(height: Responsive.height(context, 8)),
                  Text(
                    productModel.description,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 32)),

                  // Request button
                  GestureDetector(
                    onTap: productModel.isAvailable
                        ? () {
                            context
                                .read<RequestsCubit>()
                                .addRequest(productModel);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('تم إضافة الطلب بنجاح'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        : null,
                    child: Container(
                      height: Responsive.height(context, 56),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: productModel.isAvailable
                            ? AppColors.primary
                            : AppColors.grey,
                        borderRadius:
                            BorderRadius.circular(Responsive.width(context, 40)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_outline,
                              color: Colors.white,
                              size: Responsive.width(context, 22)),
                          SizedBox(width: Responsive.width(context, 8)),
                          Text(
                            productModel.isAvailable
                                ? 'اطلب هذا التبرع'
                                : 'غير متاح حالياً',
                            style: AppTextStyles.labelMedium(context),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 10),
        vertical: Responsive.height(context, 6),
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(Responsive.width(context, 8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Responsive.width(context, 14), color: AppColors.textSecondary),
          SizedBox(width: Responsive.width(context, 4)),
          Text(
            text,
            style: TextStyle(
              fontSize: Responsive.height(context, 11),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
