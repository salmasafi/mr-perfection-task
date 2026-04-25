import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../../logic/models/product_model.dart';
import '../screens/product_details.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          color: AppColors.card,
          borderRadius: BorderRadius.circular(Responsive.width(context, 20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              spreadRadius: 0,
              blurRadius: Responsive.width(context, 15),
              offset: Offset(0, Responsive.height(context, 4)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Responsive.width(context, 20)),
                      topRight: Radius.circular(Responsive.width(context, 20)),
                    ),
                    child: Image.network(
                      productModel.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
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
                                size: Responsive.width(context, 40),
                                color: AppColors.grey,
                              ),
                              SizedBox(height: Responsive.height(context, 4)),
                              Text(
                                'لا توجد صورة',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: Responsive.width(context, 10),
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // "مجاني" badge
                  Positioned(
                    top: Responsive.height(context, 8),
                    right: Responsive.width(context, 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 10),
                        vertical: Responsive.height(context, 3),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                            Responsive.width(context, 20)),
                      ),
                      child: Text(
                        'مجاني',
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: Responsive.height(context, 10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Availability indicator
                  if (!productModel.isAvailable)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(Responsive.width(context, 20)),
                            topRight:
                                Radius.circular(Responsive.width(context, 20)),
                          ),
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.width(context, 12),
                              vertical: Responsive.height(context, 6),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  Responsive.width(context, 8)),
                            ),
                            child: Text(
                              'تم الحجز',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: Responsive.height(context, 12),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(Responsive.width(context, 10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Responsive.height(context, 2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            productModel.donorName,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: Responsive.height(context, 11),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: productModel.isAvailable
                              ? () {
                                  context
                                      .read<RequestsCubit>()
                                      .addRequest(productModel);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('تمت إضافة الطلب'),
                                      backgroundColor: AppColors.primary,
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.all(
                                Responsive.width(context, 6)),
                            decoration: BoxDecoration(
                              color: productModel.isAvailable
                                  ? AppColors.primary
                                  : AppColors.grey,
                              borderRadius: BorderRadius.circular(
                                  Responsive.width(context, 8)),
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: Responsive.width(context, 16),
                            ),
                          ),
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
