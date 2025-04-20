import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
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
              spreadRadius: Responsive.width(context, 1),
              blurRadius: Responsive.width(context, 10),
              offset: Offset(0, Responsive.height(context, 3)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Responsive.width(context, 20)),
                  topRight: Radius.circular(Responsive.width(context, 20)),
                ),
                child: Image.network(
                  productModel.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${productModel.price.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber,
                                size: Responsive.width(context, 20)),
                            SizedBox(width: Responsive.width(context, 4)),
                            Text(
                              productModel.rate.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
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
