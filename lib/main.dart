import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'logic/cubit/products_cubit.dart';
import 'ui/screens/products_screen.dart';

void main() {
  runApp(ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()..getAllProducts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(context),
        home: ProductsScreen(),
      ),
    );
  }
}
