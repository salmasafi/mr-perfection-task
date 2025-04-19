// import 'package:flutter/material.dart';
// import '../core/app_colors.dart';
// import '../core/responsive.dart';

// class CategoryButton extends StatelessWidget {
//   final String? text;
//   final IconData? icon;
//   final bool selected;

//   const CategoryButton(
//       {super.key, this.text, this.icon, this.selected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: Responsive.width(context, 15),
//         vertical: Responsive.height(context, 8),
//       ),
//       decoration: BoxDecoration(
//         color: selected ? AppColors.primary : AppColors.greyLight,
//         borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
//       ),
//       child: Center(
//         child: text != null
//             ? Text(
//                 text!,
//                 style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       color: selected ? AppColors.onPrimary : AppColors.text,
//                     ),
//               )
//             : Icon(icon, color: AppColors.icon),
//       ),
//     );
//   }
// }
