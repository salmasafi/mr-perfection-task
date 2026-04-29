// موديل التبرع - بيمثل أي تبرع موجود في التطبيق
import 'incoming_request_model.dart';
import 'user_model.dart';

class ProductModel {
  final int id; // رقم التبرع في قاعدة البيانات
  final String title; // اسم التبرع
  final String description; // وصف التبرع
  final String? imageLink; // رابط الصورة (ممكن يكون فاضي)
  final UserModel donor; // بيانات المتبرع
  final List<IncomingRequestModel>? requests; // قائمة الطلبات الواردة على التبرع ده

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageLink,
    required this.donor,
    this.requests,
  });

  // getter بيرجع رابط الصورة أو صورة placeholder لو مفيش صورة
  String get image {
    // لو الـ imageLink فاضي أو null نرجع صورة placeholder من الإنترنت
    if (imageLink == null || imageLink!.isEmpty) {
      return 'https://via.placeholder.com/300';
    }
    // لو في صورة نرجعها
    return imageLink!;
  }

  // بنحول الـ JSON القادم من سوبابيز لـ ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // بنجيب بيانات المتبرع من جوا الـ profiles
    final donorData = json['profiles'] as Map<String, dynamic>?;

    // بنحول قائمة الطلبات لو موجودة
    List<IncomingRequestModel>? requestsList;
    if (json['donation_requests'] != null) {
      // بنلف على كل طلب ونحوله لـ IncomingRequestModel
      requestsList = (json['donation_requests'] as List)
          .map((req) => IncomingRequestModel.fromJson(req))
          .toList();
    }

    // بنجيب رابط الصورة ونتعامل مع كل الحالات الممكنة
    dynamic imageData = json['image_link'];
    String? finalImageLink;

    if (imageData is String && imageData.isNotEmpty && imageData != '{}') {
      // الحالة الطبيعية - رابط نص عادي
      finalImageLink = imageData;
    } else if (imageData is List && imageData.isNotEmpty) {
      // لو الصور جت كـ List ناخد أول صورة
      finalImageLink = imageData[0].toString();
    } else if (imageData is Map && imageData.isEmpty) {
      // لو جت كـ {} فاضية نخليها null
      finalImageLink = null;
    }

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'بدون عنوان',
      description: json['description'] ?? 'لا يوجد وصف',
      imageLink: finalImageLink,
      donor: UserModel.fromJson(donorData ?? {}), // بنحول بيانات المتبرع
      requests: requestsList, // قائمة الطلبات (ممكن تكون null)
    );
  }
}
