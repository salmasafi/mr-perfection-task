import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api_service.dart';
import '../models/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  ProductsLoaded(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  static List<ProductModel> generalProductsList = [];

  Future<void> getAllProducts() async {
    emit(ProductsLoading());
    List<ProductModel>? productsList = await ApiService().getAllProducts();
    if (productsList != null) {
      generalProductsList = productsList;
      emit(ProductsLoaded(productsList));
    } else {
      emit(ProductsError('حدث خطأ، يرجى المحاولة مرة أخرى'));
    }
  }

  void searchProducts(
      {required String query, required List<ProductModel> allProducts}) {
    final List<ProductModel> filteredProducts = allProducts
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(ProductsLoaded(filteredProducts));
  }
}
