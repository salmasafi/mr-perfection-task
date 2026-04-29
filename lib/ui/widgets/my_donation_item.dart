// ويدجت عنصر تبرعي - بيعرض تبرع واحد من تبرعات المستخدم مع الطلبات الواردة عليه
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import 'app_network_image.dart';
import 'incoming_request_item.dart';

class MyDonationItem extends StatelessWidget {
  final ProductModel product; // بيانات التبرع
  final Function(int) onDelete; // دالة الحذف - بتاخد الـ ID وتحذف التبرع

  const MyDonationItem({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // بنجيب قائمة الطلبات الواردة على التبرع ده
    final requests = product.requests ?? []; // لو مفيش طلبات نحط قائمة فاضية

    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 16)), // مسافة بين التبرعات
      decoration: BoxDecoration(
        color: AppColors.card, // خلفية بيضا
        borderRadius: BorderRadius.circular(Responsive.width(context, 16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5), // ظل تحت الكارت
          ),
        ],
      ),
      child: Column(
        children: [
          // ========== رأس التبرع (الصورة والاسم وزر الحذف) ==========
          Padding(
            padding: EdgeInsets.all(Responsive.width(context, 14)),
            child: Row(
              children: [
                // صورة التبرع - مربع صغير
                AppNetworkImage(
                  imageUrl: product.image,
                  width: Responsive.width(context, 70),
                  height: Responsive.width(context, 70),
                  borderRadius: Responsive.width(context, 12),
                ),
                SizedBox(width: Responsive.width(context, 14)),

                // اسم التبرع - بياخد باقي المساحة
                Expanded(
                  child: Text(
                    product.title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: Responsive.height(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                    maxLines: 2, // سطرين كحد أقصى
                    overflow: TextOverflow.ellipsis, // لو أطول يحط ...
                  ),
                ),

                // زر الحذف - أيقونة سلة مهملات حمرا
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onDelete(product.id), // بنبعت الـ ID للدالة
                ),
              ],
            ),
          ),

          // ========== قسم الطلبات الواردة (بيظهر بس لو في طلبات) ==========
          if (requests.isNotEmpty) ...[
            // خط فاصل
            Divider(height: 1, color: AppColors.greyLight),

            Padding(
              padding: EdgeInsets.all(Responsive.width(context, 14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان قسم الطلبات
                  Row(
                    children: [
                      Icon(Icons.mark_email_unread_outlined,
                          size: Responsive.width(context, 16),
                          color: AppColors.primary),
                      SizedBox(width: Responsive.width(context, 8)),
                      Text(
                        'الطلبات الواردة (${requests.length})', // عدد الطلبات
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.height(context, 12),
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.height(context, 12)),

                  // قائمة الطلبات - بنلف على كل طلب ونعرضه
                  ...requests.map((req) => IncomingRequestItem(request: req)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
