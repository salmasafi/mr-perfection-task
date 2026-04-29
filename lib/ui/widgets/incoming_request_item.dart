// ويدجت عنصر الطلب الوارد - بيعرض تفاصيل طلب واحد في شاشة "تبرعاتي"
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/incoming_request_model.dart';

class IncomingRequestItem extends StatelessWidget {
  final IncomingRequestModel request; // بيانات الطلب

  const IncomingRequestItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.height(context, 8)), // مسافة بين الطلبات
      padding: EdgeInsets.all(Responsive.width(context, 12)),
      decoration: BoxDecoration(
        color: AppColors.background, // خلفية رمادية فاتحة جداً
        borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
        border: Border.all(color: AppColors.greyLight), // حدود رمادية خفيفة
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف الأول - اسم الطالب وأيقونة الشخص
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // اسم الشخص اللي طالب التبرع
              Text(
                request.requester.fullName,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.height(context, 13),
                  color: AppColors.text,
                ),
              ),
              // أيقونة شخص على اليسار
              Icon(Icons.person_outline,
                  size: Responsive.width(context, 16), color: AppColors.grey),
            ],
          ),
          SizedBox(height: Responsive.height(context, 6)),

          // سطر العنوان
          _buildInfoRow(context, Icons.location_on_outlined,
              'العنوان: ${request.deliveryAddress}'),
          SizedBox(height: Responsive.height(context, 4)),

          // سطر الهاتف - SelectableText عشان المستخدم يقدر ينسخه
          Row(
            children: [
              Icon(Icons.phone_outlined,
                  size: Responsive.width(context, 14),
                  color: AppColors.primary), // أيقونة خضرا
              SizedBox(width: Responsive.width(context, 6)),
              Expanded(
                child: SelectableText(
                  // SelectableText بيخلي المستخدم يقدر ينسخ الرقم
                  'الهاتف: ${request.deliveryPhone}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: Responsive.height(context, 12),
                    color: AppColors.primary, // نص أخضر عشان يبان إنه قابل للنسخ
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // سطر الرسالة - بيتعرض بس لو في رسالة
          if (request.message.isNotEmpty) ...[
            SizedBox(height: Responsive.height(context, 8)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.width(context, 8)),
              decoration: BoxDecoration(
                color: AppColors.greyLight.withValues(alpha: 0.5), // خلفية شفافة شوية
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 8)),
              ),
              child: Text(
                'الرسالة: ${request.message}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: Responsive.height(context, 11),
                  color: AppColors.textSecondary,
                  height: 1.4, // مسافة بين السطور
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // دالة مساعدة لبناء صف معلومات (أيقونة + نص)
  // بنستخدمها عشان منكررش نفس الكود لكل سطر معلومات
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: Responsive.width(context, 14), color: AppColors.grey),
        SizedBox(width: Responsive.width(context, 6)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: Responsive.height(context, 12),
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
