import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/donation_request.dart';
import '../models/product_model.dart';

class RequestsState {
  final List<DonationRequest> items;

  RequestsState(this.items);

  int get totalItems => items.length;
}

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsState([]));

  void addRequest(ProductModel product) {
    final currentItems = List<DonationRequest>.from(state.items);
    final alreadyRequested = currentItems.any(
      (item) => item.product.id == product.id,
    );

    if (!alreadyRequested) {
      currentItems.add(DonationRequest(product: product));
    }

    emit(RequestsState(currentItems));
  }

  void removeRequest(int productId) {
    final currentItems = List<DonationRequest>.from(state.items);
    currentItems.removeWhere((item) => item.product.id == productId);
    emit(RequestsState(currentItems));
  }

  void clearRequests() {
    emit(RequestsState([]));
  }
}
