// موديل طلب التبرع الوارد - بيمثل طلب واحد من شخص عايز ياخد تبرع
import 'user_model.dart';

class IncomingRequestModel {
  final int id; // رقم الطلب
  final UserModel requester; // بيانات الشخص اللي طالب التبرع
  final String message; // الرسالة اللي كتبها الطالب للمتبرع
  final String deliveryAddress; // عنوان التوصيل
  final String deliveryPhone; // رقم هاتف التوصيل

  IncomingRequestModel({
    required this.id,
    required this.requester,
    required this.message,
    required this.deliveryAddress,
    required this.deliveryPhone,
  });

  // بنحول الـ JSON القادم من سوبابيز لـ IncomingRequestModel
  factory IncomingRequestModel.fromJson(Map<String, dynamic> json) {
    // بنجيب بيانات الـ requester من جوا الـ profiles
    final profiles = json['profiles'] as Map<String, dynamic>?;

    return IncomingRequestModel(
      id: json['id'] ?? 0, // لو مفيش ID نحط 0
      requester: UserModel.fromJson(profiles ?? {}), // بنحول الـ profiles لـ UserModel
      message: json['message'] ?? 'لا توجد رسالة', // لو مفيش رسالة
      deliveryAddress: json['delivery_address'] ?? 'غير محدد', // لو مفيش عنوان
      deliveryPhone: json['delivery_phone'] ?? 'غير محدد', // لو مفيش رقم
    );
  }
}
