// ويدجت الصورة من الإنترنت - بيعرض صورة من رابط مع التعامل مع حالة التحميل والخطأ
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl; // رابط الصورة
  final double? width; // العرض (اختياري)
  final double? height; // الارتفاع (اختياري)
  final BoxFit fit; // طريقة ملء الصورة للمساحة
  final double borderRadius; // دائرية الحواف

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover, // افتراضياً بتملأ المساحة وتقص الزيادة
    this.borderRadius = 0, // افتراضياً من غير دائرية
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // بنقص الصورة عشان تبقى بالشكل الدايري المطلوب
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,

        // لما الصورة تفشل في التحميل (رابط غلط أو مفيش إنترنت)
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.greyLight, // خلفية رمادية فاتحة
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  // لو الصورة صغيرة نخلي الأيقونة أصغر
                  size: (width != null && width! < 100)
                      ? width! * 0.4
                      : Responsive.width(context, 40),
                  color: AppColors.grey,
                ),
                // بنعرض النص بس لو الصورة مش صغيرة جداً
                if (width == null || width! > 80) ...[
                  SizedBox(height: Responsive.height(context, 4)),
                  Text(
                    'لا توجد صورة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.grey,
                      fontSize: Responsive.width(context, 10),
                    ),
                  ),
                ],
              ],
            ),
          );
        },

        // لما الصورة بتتحمل بنعرض loading indicator
        loadingBuilder: (context, child, loadingProgress) {
          // لو التحميل خلص نعرض الصورة
          if (loadingProgress == null) return child;

          // لو لسه بتتحمل نعرض دايرة التحميل
          return Container(
            width: width,
            height: height,
            color: AppColors.greyLight,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                // بنحسب نسبة التحميل لو السيرفر بعتلنا الحجم الكلي
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null, // لو مش عارفين الحجم نعرض دايرة مش محددة
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
