// ملف الـ API - ده اللي بيتكلم مع سوبابيز (قاعدة البيانات)
// كل العمليات اللي بتحتاج إنترنت موجودة هنا
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ApiService {
  // بنجيب الـ client بتاع سوبابيز عشان نعمل بيه الطلبات
  final SupabaseClient _supabase = Supabase.instance.client;

  // ========== 1. جلب كل التبرعات ==========
  Future<List<ProductModel>> getAllProducts() async {
    try {
      // بنعمل SELECT من جدول donations مع بيانات المتبرع
      final response = await _supabase.from('donations').select('''
            id,
            title,
            description,
            image_link,
            profiles!donor_id ( id, full_name, phone_number, address )
          ''').order('id', ascending: false); // الأحدث أول

      // بنحول كل row في النتيجة لـ ProductModel
      final products = (response as List).map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return products;
    } catch (e) {
      print('Supabase Fetch Error: $e'); // بنطبع الخطأ في الـ console
      return []; // لو حصل خطأ نرجع قائمة فاضية
    }
  }

  // ========== 2. جلب تبرعات المستخدم الحالي مع الطلبات الواردة ==========
  Future<List<ProductModel>> getMyDonations() async {
    try {
      // بنجيب المستخدم الحالي
      final user = _supabase.auth.currentUser;
      if (user == null) return []; // لو مفيش يوزر مسجل نرجع قائمة فاضية

      // بنجيب التبرعات بتاعت المستخدم ده بس مع الطلبات الواردة عليها
      final response = await _supabase.from('donations').select('''
        id,
        title,
        description,
        image_link,
        profiles!donor_id ( id, full_name, phone_number, address ),
        donation_requests (
          id,
          message,
          delivery_address,
          delivery_phone,
          profiles!requester_id ( id, full_name, phone_number, address )
        )
      ''').eq('donor_id', user.id) // فلتر على الـ donor_id بتاع المستخدم الحالي
          .order('id', ascending: false); // الأحدث أول

      // بنحول كل row لـ ProductModel
      return (response as List).map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    } catch (e) {
      print('Fetch My Donations Error: $e');
      return [];
    }
  }

  // ========== 3. حذف تبرع ==========
  Future<bool> deleteDonation(int donationId) async {
    try {
      // لازم نحذف الطلبات الواردة الأول عشان في foreign key constraint
      await _supabase
          .from('donation_requests')
          .delete()
          .eq('donation_id', donationId);

      // بعدين نحذف التبرع نفسه
      await _supabase.from('donations').delete().eq('id', donationId);

      return true; // الحذف نجح
    } catch (e) {
      print('Delete Donation Error: $e');
      return false; // الحذف فشل
    }
  }

  // ========== 4. إضافة تبرع جديد ==========
  Future<bool> createDonation({
    required String title, // اسم التبرع (إجباري)
    required String description, // الوصف (إجباري)
    String? imageUrl, // رابط الصورة (اختياري)
  }) async {
    try {
      // بنجيب المستخدم الحالي عشان نحط الـ donor_id
      final user = _supabase.auth.currentUser;
      if (user == null) return false; // لو مفيش يوزر مسجل نرجع false

      // بنضيف التبرع في جدول donations
      await _supabase.from('donations').insert({
        'title': title,
        'description': description,
        'donor_id': user.id, // الـ ID بتاع المتبرع
        'image_link': imageUrl, // رابط الصورة (ممكن يكون null)
      });

      return true; // الإضافة نجحت
    } catch (e) {
      print('Create Donation Error: $e');
      return false; // الإضافة فشلت
    }
  }

  // ========== 5. إرسال طلب للحصول على تبرع ==========
  Future<bool> createDonationRequest({
    required int productId, // رقم التبرع اللي عايزه
    required String fullName, // اسم الطالب
    required String phone, // رقم هاتفه
    required String address, // عنوانه
    String? message, // رسالة للمتبرع (اختياري)
  }) async {
    try {
      // بنجيب المستخدم الحالي
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // بنحدث بيانات الـ profile بتاع المستخدم بالمعلومات الجديدة
      await _supabase.from('profiles').update({
        'full_name': fullName,
        'phone_number': phone,
        'address': address,
      }).eq('id', user.id); // بس الـ profile بتاعه هو

      // بنضيف الطلب في جدول donation_requests
      await _supabase.from('donation_requests').insert({
        'donation_id': productId, // رقم التبرع
        'requester_id': user.id, // رقم الطالب
        'delivery_address': address, // عنوان التوصيل
        'delivery_phone': phone, // رقم هاتف التوصيل
        'message': message, // الرسالة (ممكن تكون null)
      });

      return true; // الطلب اتبعت بنجاح
    } catch (e) {
      print('Create Request Error: $e');
      return false; // الطلب فشل
    }
  }
}
