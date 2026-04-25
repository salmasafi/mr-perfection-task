import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../../logic/cubit/products_cubit.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/products_gridview.dart';
import '../widgets/search_button.dart';
import 'add_product_screen.dart';
import 'cart_screen.dart';
import 'my_products_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeScreen(context),
      const CartScreen(),
      const AddProductScreen(),
      const MyProductsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.width(context, 20),
          vertical: Responsive.height(context, 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مرحباً 👋",
                      style: TextStyle(fontFamily: 'Cairo', 
                        fontSize: Responsive.height(context, 24),
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: Responsive.height(context, 2)),
                    Text(
                      "تصفح التبرعات المتاحة",
                      style: TextStyle(fontFamily: 'Cairo', 
                        fontSize: Responsive.height(context, 13),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (context, state) {
                    if (state.totalItems == 0) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = 1),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.width(context, 10)),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                              Responsive.width(context, 14)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.volunteer_activism,
                              color: Colors.white,
                              size: Responsive.width(context, 18),
                            ),
                            SizedBox(width: Responsive.width(context, 4)),
                            Text(
                              '${state.totalItems}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Responsive.height(context, 14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // Welcome banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.width(context, 20)),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💚 ساهم في العطاء',
                    style: TextStyle(fontFamily: 'Cairo', 
                      fontSize: Responsive.height(context, 18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 6)),
                  Text(
                    'تبرع بما لا تحتاج، واطلب ما يحتاجه غيرك.\nكل شيء هنا مجاني.',
                    style: TextStyle(fontFamily: 'Cairo', 
                      fontSize: Responsive.height(context, 12),
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // Search bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: Responsive.width(context, 50),
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.width(context, 15)),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(
                          Responsive.width(context, 15)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: AppColors.primary,
                      style: TextStyle(fontFamily: 'Cairo', 
                        fontSize: Responsive.height(context, 14),
                      ),
                      decoration: InputDecoration(
                        hintText: "ابحث عن تبرع...",
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: Responsive.height(context, 14),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          context.read<ProductsCubit>().getAllProducts();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 10)),
                SearchButton(searchController: _searchController),
              ],
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // Products grid
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoaded) {
                  return ProductsGridView(state.products);
                } else if (state is ProductsError) {
                  return ProductsErrorWidget(state.message);
                } else {
                  return const ProductsLoadingWidget();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
