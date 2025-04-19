import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/responsive.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final double price;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                image,
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
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("\$${price.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
