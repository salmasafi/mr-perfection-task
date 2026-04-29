// موديل المستخدم - بيمثل بيانات أي يوزر في التطبيق (المتبرع أو الطالب)
class UserModel {
  final String id; // الـ ID الفريد للمستخدم من سوبابيز
  final String fullName; // الاسم الكامل
  final String? phoneNumber; // رقم الهاتف (ممكن يكون فاضي)
  final String? address; // العنوان (ممكن يكون فاضي)

  UserModel({
    required this.id,
    required this.fullName,
    this.phoneNumber, // مش إجباري
    this.address, // مش إجباري
  });

  // factory constructor - بيحول الـ JSON القادم من سوبابيز لـ UserModel
  // بنستخدم ?? عشان لو الحقل فاضي نحط قيمة افتراضية
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '', // لو مفيش ID نحط string فاضي
      fullName: json['full_name'] ?? 'مستخدم مجهول', // لو مفيش اسم
      phoneNumber: json['phone_number'], // ممكن يكون null وده تمام
      address: json['address'], // ممكن يكون null وده تمام
    );
  }
}
