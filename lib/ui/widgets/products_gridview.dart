import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../logic/models/product_model.dart';
import 'product_card.dart';

class ProductsGridView extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsGridView(
    this.products, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Responsive.height(context, 20),
        crossAxisSpacing: Responsive.width(context, 20),
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(
        productModel: products[index],
      ),
    );
  }
}
