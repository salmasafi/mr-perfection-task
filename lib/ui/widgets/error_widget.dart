import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/logic/cubit/products_cubit.dart';
import '../../core/responsive.dart';

class ProductsErrorWidget extends StatelessWidget {
  final String message;
  const ProductsErrorWidget(
    this.message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Responsive.height(context, 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: Responsive.height(context, 20),
            ),
            MaterialButton(
              onPressed: () {
                context.read<ProductsCubit>().getAllProducts();
              },
              color: Theme.of(context).primaryColor,
              minWidth: Responsive.width(context, 150),
              height: Responsive.height(context, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Responsive.width(context, 15),
                ),
              ),
              child: Text(
                'Try again',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
