// ملف الـ Cubit - ده اللي بيتحكم في حالة المنتجات في التطبيق
// الـ Cubit زي المخ اللي بيقرر إيه اللي يتعرض على الشاشة
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api_service.dart';
import '../models/product_model.dart';

// ========== الحالات (States) ==========
// كل حالة بتمثل موقف مختلف في التطبيق

// الحالة الابتدائية - لما التطبيق بيبدأ ومحصلش حاجة لسه
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

// حالة التحميل - لما بنجيب البيانات من السيرفر
class ProductsLoading extends ProductsState {}

// حالة النجاح - لما البيانات وصلت بنحط فيها قائمة المنتجات
class ProductsLoaded extends ProductsState {
  final List<ProductModel> products; // قائمة التبرعات اللي جت من السيرفر
  ProductsLoaded(this.products);
}

// حالة الخطأ - لما حصل مشكلة بنحط فيها رسالة الخطأ
class ProductsError extends ProductsState {
  final String message; // رسالة الخطأ اللي هتتعرض للمستخدم
  ProductsError(this.message);
}

// ========== الـ Cubit ==========
// ده اللي بيتحكم في كل العمليات المتعلقة بالمنتجات
class ProductsCubit extends Cubit<ProductsState> {
  final ApiService _apiService; // بنستخدمه عشان نتكلم مع السيرفر

  // الـ constructor - بياخد الـ ApiService ويبدأ بالحالة الابتدائية
  ProductsCubit(this._apiService) : super(ProductsInitial()) {
    fetchProducts(); // بنجيب المنتجات فوراً لما الـ Cubit يتعمل
  }

  // دالة جلب المنتجات من السيرفر
  Future<void> fetchProducts() async {
    emit(ProductsLoading()); // بنقول للشاشة "انتظري، بنجيب البيانات"
    try {
      // بنطلب المنتجات من الـ API
      final products = await _apiService.getAllProducts();
      emit(ProductsLoaded(products)); // نجح! بنبعت المنتجات للشاشة
    } catch (e) {
      // حصل خطأ - بنبعت رسالة خطأ للشاشة
      emit(ProductsError('حدث خطأ أثناء تحميل المنتجات'));
    }
  }
}
