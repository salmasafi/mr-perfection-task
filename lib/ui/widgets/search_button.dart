import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/products_cubit.dart';

class SearchButton extends StatelessWidget {
  final TextEditingController searchController;

  const SearchButton({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ProductsCubit>().searchProducts(
              query: searchController.text.trim().toLowerCase(),
              allProducts: ProductsCubit.generalProductsList,
            );
      },
      child: Container(
        height: Responsive.width(context, 50),
        width: Responsive.width(context, 50),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
        ),
        child: const Icon(Icons.search, color: AppColors.onPrimary),
      ),
    );
  }
}
