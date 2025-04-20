import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_colors.dart';
import '../../core/responsive.dart';
import '../../logic/cubit/products_cubit.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/products_gridview.dart';
import '../widgets/search_button.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 20),
            vertical: Responsive.height(context, 20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Welcome 👋",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: Responsive.height(context, 20)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(context, 15)),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(
                            Responsive.width(context, 15)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Responsive.width(context, 10)),
                  SearchButton(),
                ],
              ),
              SizedBox(height: Responsive.height(context, 20)),
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoaded) {
                    return ProductsGridView(state.products);
                  } else if (state is ProductsError) {
                    return ProductsErrorWidget(state.message);
                  } else {
                    return ProductsLoadingWidget();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
