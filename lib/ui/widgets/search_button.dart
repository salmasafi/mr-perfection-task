import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/responsive.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Responsive.width(context, 15),
        ),
      ),
      height: Responsive.width(context, 50),
      minWidth: Responsive.width(context, 50),
      child: Icon(Icons.search, color: AppColors.onPrimary),
    );
  }
}
