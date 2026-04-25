class IncomingRequestModel {
  final int id;
  final String requesterName;
  final String message;
  final String deliveryAddress;
  final String deliveryPhone;
  final String status;
  final String createdAt;

  IncomingRequestModel({
    required this.id,
    required this.requesterName,
    required this.message,
    required this.deliveryAddress,
    required this.deliveryPhone,
    required this.status,
    required this.createdAt,
  });

  factory IncomingRequestModel.fromJson(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>?;
    return IncomingRequestModel(
      id: json['id'] ?? 0,
      requesterName: profiles?['full_name'] ?? 'مستخدم مجهول',
      message: json['message'] ?? 'لا توجد رسالة',
      deliveryAddress: json['delivery_address'] ?? 'غير محدد',
      deliveryPhone: json['delivery_phone'] ?? 'غير محدد',
      status: json['status'] ?? 'قيد الانتظار',
      createdAt: json['created_at'] ?? '',
    );
  }
}
