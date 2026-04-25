import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/custom_button.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'طلبات التبرع',
          style: TextStyle(fontFamily: 'Cairo', 
            color: AppColors.text,
            fontSize: Responsive.height(context, 20),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.volunteer_activism_outlined,
                    size: Responsive.width(context, 80),
                    color: AppColors.greyMedium,
                  ),
                  SizedBox(height: Responsive.height(context, 16)),
                  Text(
                    'لا توجد طلبات بعد',
                    style: TextStyle(fontFamily: 'Cairo', 
                      fontSize: Responsive.height(context, 16),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 8)),
                  Text(
                    'تصفح التبرعات واطلب ما يناسبك',
                    style: TextStyle(fontFamily: 'Cairo', 
                      fontSize: Responsive.height(context, 13),
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(Responsive.width(context, 16)),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final request = state.items[index];
                    return CartItemCard(
                      donationRequest: request,
                      onRemove: () {
                        context
                            .read<RequestsCubit>()
                            .removeRequest(request.product.id);
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(Responsive.width(context, 16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'عدد الطلبات:',
                            style: TextStyle(fontFamily: 'Cairo', 
                              fontSize: Responsive.height(context, 16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            '${state.totalItems} تبرع',
                            style: TextStyle(fontFamily: 'Cairo', 
                              fontSize: Responsive.height(context, 18),
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.height(context, 16)),
                      CustomButton(
                        text: 'تأكيد الطلبات',
                        icon: Icons.check_circle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
