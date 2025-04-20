import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;
  const ProductDetailsScreen(this.productModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.width(context, 16),
          vertical: Responsive.height(context, 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Responsive.height(context, 400),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      productModel.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: Responsive.height(context, 24),
                    left: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: AppColors.onPrimary,
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),
            Text(
              productModel.title,
              style: AppTextStyles.titleLarge(context),
            ),
            SizedBox(height: Responsive.height(context, 8)),
            Text(
              productModel.category,
              style: AppTextStyles.bodyLarge(context),
            ),
            SizedBox(height: Responsive.height(context, 8)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(' ${productModel.rate}  ',
                    style: AppTextStyles.bodyLarge(context)),
                Text(
                  '(${productModel.reviews} reviews)',
                  style: AppTextStyles.bodySmall(context)
                      .copyWith(color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: Responsive.height(context, 16)),
            Text(
              productModel.description,
              style: AppTextStyles.bodySmall(context),
            ),
            SizedBox(height: Responsive.height(context, 24)),
            MaterialButton(
              onPressed: () {},
              color: AppColors.primary,
              height: Responsive.height(context, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              minWidth: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  Text(
                    'Add to Cart | \$${productModel.price}',
                    style: AppTextStyles.labelMedium(context),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.height(context, 16),
            ),
          ],
        ),
      ),
    );
  }
}
