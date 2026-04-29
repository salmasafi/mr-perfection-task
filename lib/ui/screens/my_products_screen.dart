// شاشة تبرعاتي - بتعرض كل التبرعات اللي أضافها المستخدم الحالي
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import '../widgets/my_donation_item.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_dialog.dart';
import 'add_product_screen.dart';
import '../../logic/api/api_service.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  // دالة حذف تبرع - بتاخد الـ ID وتسأل المستخدم يأكد الحذف
  void _deleteDonation(int id) async {
    // بنعرض ديالوج تأكيد الحذف وننتظر رد المستخدم
    final confirm = await AppDialog.confirm(
      context: context,
      title: 'حذف التبرع',
      content:
          'هل أنت متأكد من حذف هذا التبرع؟ سيتم حذف جميع الطلبات المتعلقة به أيضاً.',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      isDestructive: true, // بيخلي زر الحذف أحمر
    );

    // لو المستخدم أكد الحذف
    if (confirm == true) {
      final success = await ApiService().deleteDonation(id);
      if (success && mounted) {
        setState(() {}); // بنعيد بناء الشاشة عشان تتحدث القائمة
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تبرعاتي',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.text,
            fontSize: Responsive.height(context, 20),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      // FutureBuilder بيبني الـ UI بناءً على حالة الـ Future
      body: FutureBuilder<List<ProductModel>>(
        future: ApiService().getMyDonations(), // بنجيب تبرعات المستخدم
        builder: (context, snapshot) {
          // حالة التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProductsLoadingWidget();
          }

          // حالة الخطأ
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'حدث خطأ في جلب بيانات التبرعات',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  // زر إعادة المحاولة - بيعيد بناء الـ FutureBuilder
                  TextButton(
                    onPressed: () => setState(() {}),
                    child: const Text('حاول مجدداً',
                        style: TextStyle(
                            fontFamily: 'Cairo', color: AppColors.primary)),
                  ),
                ],
              ),
            );
          }

          // بنجيب القائمة أو قائمة فاضية لو مفيش بيانات
          final myProducts = snapshot.data ?? [];

          // حالة القائمة الفاضية - مفيش تبرعات
          if (myProducts.isEmpty) {
            return EmptyStateView(
              title: 'لم تقم بإضافة أي تبرعات بعد',
              subtitle:
                  'كرمك يمكن أن يغير حياة شخص ما. ابدأ الآن بإضافة أول تبرع لك.',
              buttonText: 'أضف تبرع جديد',
              onActionPressed: () {
                // بنروح لشاشة إضافة تبرع وبعدين نحدث الشاشة دي
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductScreen(),
                  ),
                ).then((_) => setState(() {})); // لما نرجع نحدث الشاشة
              },
            );
          }

          // حالة النجاح - بنعرض قائمة التبرعات
          return ListView.builder(
            padding: EdgeInsets.all(Responsive.width(context, 16)),
            itemCount: myProducts.length, // عدد التبرعات
            itemBuilder: (context, index) {
              // بنبني عنصر لكل تبرع
              return MyDonationItem(
                product: myProducts[index],
                onDelete: _deleteDonation, // بنبعت دالة الحذف
              );
            },
          );
        },
      ),
    );
  }
}
