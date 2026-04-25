import 'incoming_request_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String image;
  final String donorName;
  final String condition;
  final bool isAvailable;
  final String createdAt;
  final List<IncomingRequestModel>? requests;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.donorName,
    required this.condition,
    this.isAvailable = true,
    required this.createdAt,
    this.requests,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<IncomingRequestModel>? parsedRequests;
    if (json['donation_requests'] != null) {
      parsedRequests = (json['donation_requests'] as List)
          .map((r) => IncomingRequestModel.fromJson(r))
          .toList();
    }

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'بدون عنوان',
      description: json['description'] ?? 'لا يوجد وصف',
      category: json['category'] ?? 'أخرى',
      image: json['image'] ??
          'http://www.shutterstock.com/image-vector/mystery-contest-cardboard-box-question-260nw-2472419999.jpg',
      donorName: json['donor_name'] ?? 'متبرع مجهول',
      condition: json['condition'] ?? 'مستعمل جيد',
      isAvailable: json['is_available'] ?? true,
      createdAt: json['created_at'] ?? '',
      requests: parsedRequests,
    );
  }
}
