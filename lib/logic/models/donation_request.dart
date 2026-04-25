import 'product_model.dart';

class DonationRequest {
  final ProductModel product;
  final String? message;

  DonationRequest({
    required this.product,
    this.message,
  });
}
