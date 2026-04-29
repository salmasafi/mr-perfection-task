// الشاشة الرئيسية - بتحتوي على الـ Bottom Navigation وكل التابات
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import 'auth/login_screen.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/products_cubit.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/products_gridview.dart';
import '../widgets/empty_state_view.dart';
import 'add_product_screen.dart';
import 'my_products_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _currentIndex = 0; // رقم التاب الحالي (0 = الرئيسية)

  @override
  Widget build(BuildContext context) {
    // قائمة الشاشات - كل تاب بيعرض شاشة مختلفة
    final screens = [
      _buildHomeScreen(context), // تاب 0: الرئيسية
      AddProductScreen(
        // تاب 1: إضافة تبرع
        onDonationPublished: () {
          // لما التبرع يتنشر: نحدث المنتجات ونرجع للرئيسية
          context.read<ProductsCubit>().fetchProducts();
          setState(() => _currentIndex = 0); // نروح تاب الرئيسية
        },
      ),
      const MyProductsScreen(), // تاب 2: تبرعاتي
    ];

    return Scaffold(
      // بنعرض الشاشة المناسبة حسب التاب المختار
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            // تاب الخروج - بنعرض ديالوج تأكيد
            _showLogoutDialog(context);
          } else {
            // لو ضغط على الرئيسية نحدث المنتجات
            if (index == 0) {
              context.read<ProductsCubit>().fetchProducts();
            }
            // بنغير التاب
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

  // دالة عرض ديالوج تأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          style: TextStyle(fontFamily: 'Cairo'),
          textAlign: TextAlign.center,
        ),
        actions: [
          // زر الإلغاء
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          // زر الخروج
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut(); // بنسجل خروج من سوبابيز
              if (context.mounted) {
                // بنروح لشاشة الدخول ونمسح كل الشاشات السابقة
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false, // بنمسح كل الـ stack
                );
              }
            },
            child: const Text(
              'خروج',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.red, // أحمر عشان هو action خطير
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء شاشة الرئيسية (تاب 0)
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
            // ========== الهيدر ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // تحية الترحيب
                    Text(
                      "مرحباً 👋",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: Responsive.height(context, 24),
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: Responsive.height(context, 2)),
                    // نص توضيحي
                    Text(
                      "تصفح التبرعات المتاحة",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: Responsive.height(context, 13),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // ========== البانر الترحيبي الأخضر ==========
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.width(context, 20)),
              decoration: BoxDecoration(
                color: AppColors.primary, // خلفية خضرا
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💚 ساهم في العطاء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: Responsive.height(context, 18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary, // أبيض
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 6)),
                  Text(
                    'تبرع بما لا تحتاج، واطلب ما يحتاجه غيرك.\nكل شيء هنا مجاني.',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: Responsive.height(context, 12),
                      color: Colors.white70, // أبيض شفاف شوية
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // ========== قائمة التبرعات ==========
            // BlocBuilder بيعيد بناء الـ UI كل ما الـ state تتغير
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoaded) {
                  // نجح جلب البيانات
                  if (state.products.isEmpty) {
                    // مفيش تبرعات - بنعرض شاشة فارغة
                    return Padding(
                      padding: EdgeInsets.only(
                          top: Responsive.height(context, 40)),
                      child: EmptyStateView(
                        title: 'لا توجد منتجات متبرع بها الآن',
                        subtitle:
                            'عد مرة أخرى لاحقاً أو ابدأ بتبرعك الآن لتساعد غيرك.',
                        buttonText: 'ابدأ بالتبرع الآن',
                        onActionPressed: () {
                          // بنروح لتاب إضافة تبرع
                          setState(() => _currentIndex = 1);
                        },
                      ),
                    );
                  }
                  // في تبرعات - بنعرضها في الـ Grid
                  return ProductsGridView(state.products);
                } else if (state is ProductsError) {
                  // حصل خطأ - بنعرض ويدجت الخطأ مع زر إعادة المحاولة
                  return ProductsErrorWidget(state.message);
                } else {
                  // بيتحمل - بنعرض دايرة التحميل
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
