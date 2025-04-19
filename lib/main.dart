import 'package:flutter/material.dart';
import 'package:task/core/app_theme.dart';
import 'package:task/screens/proucts_screen.dart';

void main() {
  runApp(ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(context),
      home: ProductsScreen(),
    );
  }

}
