import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/logic/api/api_service.dart';
import '../models/product_model.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    List<ProductModel>? productsList = await ApiService().getAllProducts();
    
    if (productsList != null) {
      emit(ProductsLoaded(productsList!));
    } else {
      emit(ProductsError('There is an error, please try again'));
    }
  }
}
