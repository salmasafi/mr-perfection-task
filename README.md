
# MrPerceptionTask

This Flutter application fetches and displays a list of products from a remote API, providing search functionality via a `TextField`. It’s built using Flutter BLoC (Cubit) for state management, Dio for networking, and a responsive UI.

----------

## Prerequisites

-   Flutter SDK ≥ 3.x
    
-   Dart SDK ≥ 2.x
    
-   Android Studio or Xcode (for emulators or real devices)
    
-   Git
    
-   Internet connection (for fetching packages and API data)
    

----------

## Getting Started

1.  **Clone the repository**
    
    ```bash
    git clone https://github.com/salmasafi/mr-perfection-task.git
    cd mr-perfection-task
    
    ```
    
2.  **Install dependencies & permissions**
    
    ```bash
    flutter pub get
    
    ```
    
    Ensure `AndroidManifest.xml` (`android/app/src/main/AndroidManifest.xml`) includes:
    
    ```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <application android:label="MrPerceftionTask" ...>
    
    ```
    
3.  **Run the app**
    
    ```bash
    flutter run
    
    ```
    

----------

## Project Structure

```text
lib/
 ├── core/
 │    ├── utils/
 │    │    └── responsive.dart            # Responsive sizing helper
 │    └── theme/
 │         ├── app_colors.dart            # Centralized color palette
 │         ├── app_text_styles.dart       # Responsive text styles
 │         └── app_theme.dart             # Overall theme configuration
 ├── logic/
 │    ├── api/
 │    │    └── api_service.dart           # Dio-based network client
 │    ├── cubit/
 │    │    ├── products_cubit.dart        # Business logic (Cubit)
 │    │    └── products_state.dart        # Cubit states definitions
 │    └── models/
 │         └── product_model.dart         # Data model for products
 ├── ui/
 │    ├── screens/
 │    │    ├── home_screen.dart           # Product list & search UI
 │    │    └── product_details_screen.dart# Product details UI
 │    └── widgets/                        # Reusable widgets
 └── main.dart                            # App entry point

```

----------

## Theme & Responsiveness

-   **Responsive**: All dimensions and font sizes scale via `Responsive.width(context, value)` and `Responsive.height(context, value)`.
    
-   **AppColors**: Centralized color constants in `AppColors` for consistent theming.
    
-   **AppTextStyles**: Text styles (`titleLarge()`, `titleMedium()`, `bodySmall()`, etc.) that compute font sizes responsively.
    
-   **AppTheme**: Consolidates Material theme settings in `app_theme.dart`.
    

----------

## State Management: ProductsCubit

Handles product loading and searching.

**File:** `logic/cubit/products_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/logic/api/api_service.dart';
import '../models/product_model.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  List<ProductModel> productsList = [];

  Future<void> getAllProducts() async {
    emit(ProductsLoading());

    productsList = await ApiService().getAllProducts() ?? [];

    if (productsList.isEmpty) {
      emit(ProductsLoaded(productsList));
    } else {
      emit(ProductsError('There is an error, please try again'));
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


```

**States:** `logic/cubit/products_state.dart`

```dart
part of 'products_cubit.dart';

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

```

----------

## Networking: ApiService

Fetches product list from FakeStore API using Dio.

**File:** `logic/api/api_service.dart`

```dart
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


```

----------

## UI Workflow

1.  **Home Screen**: On launch, `ProductsCubit.getAllProducts()` loads all products.
    
2.  **Search**: Typing in the search field and tapping the icon calls `searchProducts()`.
    
3.  **Display**: `BlocBuilder` rebuilds UI on `ProductsLoaded` state.
    
4.  **Details**: Tap a product to navigate to `ProductDetailsScreen`.
    

----------

## Next Steps

-   Implement caching for offline support.
    
-   Add cart management and checkout flow.