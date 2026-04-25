import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import '../widgets/custom_button.dart';
import 'add_product_screen.dart';
import '../../logic/api/api_service.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تبرعاتي',
          style: TextStyle(fontFamily: 'Cairo', 
            color: AppColors.text,
            fontSize: Responsive.height(context, 20),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: ApiService().getMyDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ في جلب بيانات التبرعات',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.red),
              ),
            );
          }

          final myProducts = snapshot.data ?? [];

          return myProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: Responsive.width(context, 80),
                        color: AppColors.greyMedium,
                      ),
                      SizedBox(height: Responsive.height(context, 16)),
                      Text(
                        'لم تقم بإضافة أي تبرعات بعد',
                        style: TextStyle(fontFamily: 'Cairo', 
                          fontSize: Responsive.height(context, 16),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: Responsive.height(context, 24)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(context, 32),
                        ),
                        child: CustomButton(
                          text: 'أضف تبرع جديد',
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddProductScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(Responsive.width(context, 16)),
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
                    final product = myProducts[index];
                    final requests = product.requests ?? [];
                    
                    return Container(
                      margin: EdgeInsets.only(bottom: Responsive.height(context, 16)),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(Responsive.width(context, 16)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            spreadRadius: 0,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Product Info
                          Padding(
                            padding: EdgeInsets.all(Responsive.width(context, 14)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
                                  child: Image.network(
                                    product.image,
                                    width: Responsive.width(context, 70),
                                    height: Responsive.width(context, 70),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      width: Responsive.width(context, 70),
                                      height: Responsive.width(context, 70),
                                      color: AppColors.greyLight,
                                      child: const Icon(Icons.image_not_supported, color: AppColors.grey),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Responsive.width(context, 14)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: Responsive.height(context, 14),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.text,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: Responsive.height(context, 6)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Responsive.width(context, 10),
                                          vertical: Responsive.height(context, 3),
                                        ),
                                        decoration: BoxDecoration(
                                          color: product.isAvailable ? AppColors.primary : AppColors.grey,
                                          borderRadius: BorderRadius.circular(Responsive.width(context, 6)),
                                        ),
                                        child: Text(
                                          product.isAvailable ? 'متاح' : 'تم الحجز',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Responsive.height(context, 10),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Requests Section
                          if (requests.isNotEmpty) ...[
                            Divider(height: 1, color: AppColors.greyLight),
                            Padding(
                              padding: EdgeInsets.all(Responsive.width(context, 14)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الطلبات الواردة (${requests.length})',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.height(context, 12),
                                      color: AppColors.text,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.height(context, 10)),
                                  ...requests.map((req) => Container(
                                    margin: EdgeInsets.only(bottom: Responsive.height(context, 8)),
                                    padding: EdgeInsets.all(Responsive.width(context, 10)),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(Responsive.width(context, 8)),
                                      border: Border.all(color: AppColors.greyLight),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              req.requesterName,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.bold,
                                                fontSize: Responsive.height(context, 13),
                                              ),
                                            ),
                                            Text(
                                              req.status,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: req.status == 'مقبول' ? Colors.green : (req.status == 'مرفوض' ? Colors.red : AppColors.primary),
                                                fontSize: Responsive.height(context, 11),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Responsive.height(context, 4)),
                                        Text(
                                          'العنوان: ${req.deliveryAddress} - الهاتف: ${req.deliveryPhone}',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: Responsive.height(context, 11),
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        if (req.message.isNotEmpty) ...[
                                          SizedBox(height: Responsive.height(context, 4)),
                                          Text(
                                            'الرسالة: ${req.message}',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: Responsive.height(context, 11),
                                              color: AppColors.text,
                                            ),
                                          ),
                                        ],
                                        if (req.status == 'قيد الانتظار') ...[
                                          SizedBox(height: Responsive.height(context, 8)),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green,
                                                    minimumSize: Size(0, Responsive.height(context, 30)),
                                                  ),
                                                  onPressed: () async {
                                                    await ApiService().updateRequestStatus(req.id, 'مقبول');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyProductsScreen()));
                                                  },
                                                  child: const Text('قبول', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                                                ),
                                              ),
                                              SizedBox(width: Responsive.width(context, 8)),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    minimumSize: Size(0, Responsive.height(context, 30)),
                                                  ),
                                                  onPressed: () async {
                                                    await ApiService().updateRequestStatus(req.id, 'مرفوض');
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyProductsScreen()));
                                                  },
                                                  child: const Text('رفض', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ],
                                    ),
                                  )).toList(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
