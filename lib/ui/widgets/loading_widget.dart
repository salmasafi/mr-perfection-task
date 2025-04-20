import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/responsive.dart';

class ProductsLoadingWidget extends StatelessWidget {
  const ProductsLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(context, 500),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
