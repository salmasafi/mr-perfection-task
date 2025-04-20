import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<ProductModel>?> getAllProducts() async {
    try {
      final response = await _dio.get('$baseUrl/products');
      if (response.statusCode == 200) {
        List products = response.data;
        List<ProductModel> productModels = [];
        for (var product in products) {
          productModels.add(ProductModel.fromApi(product));
        }
        return productModels;
      } else {
        print(response.statusCode);
        print(response.data);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
