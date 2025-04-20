import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/core/app_theme.dart';
import 'package:task/logic/cubit/products_cubit.dart';
import 'package:task/ui/screens/proucts_screen.dart';

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
