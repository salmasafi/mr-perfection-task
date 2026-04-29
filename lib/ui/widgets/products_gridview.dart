// ويدجت الـ Grid - بيعرض التبرعات في شبكة عمودين
import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import 'product_card.dart';

class ProductsGridView extends StatelessWidget {
  final List<ProductModel> products; // قائمة التبرعات اللي هتتعرض

  const ProductsGridView(
    this.products, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true, // بياخد بس المساحة اللي محتاجها (مش بيملأ الشاشة كلها)
      physics:
          const NeverScrollableScrollPhysics(), // بيمنع الـ scroll الداخلي عشان الـ scroll الخارجي يشتغل
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عمودين
        mainAxisSpacing: Responsive.height(context, 20), // مسافة بين الصفوف
        crossAxisSpacing: Responsive.width(context, 20), // مسافة بين الأعمدة
        childAspectRatio: 0.65, // نسبة العرض للارتفاع (الكارت أطول من عرضه)
      ),
      itemCount: products.length, // عدد التبرعات
      // بنبني كارت لكل تبرع
      itemBuilder: (context, index) => ProductCard(
        productModel: products[index], // بنبعت بيانات التبرع للكارت
      ),
    );
  }
}
