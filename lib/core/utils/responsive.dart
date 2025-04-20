import 'package:flutter/material.dart';

class Responsive {
  static double height(BuildContext context, double value) => MediaQuery.of(context).size.height * (value / 812);
  static double width(BuildContext context, double value) => MediaQuery.of(context).size.width * (value / 375);
}
