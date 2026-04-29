import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. جلب كل المنتجات
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _supabase.from('products').select('''
            id,
            title,
            description,
            image_link,
            profiles!donor_id ( id, full_name, phone_number, address )
          ''').order('id', ascending: false);

      final products = (response as List).map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return products;
    } catch (e) {
      print('Supabase Fetch Error: $e');
      return [];
    }
  }

  // 2. جلب منتجات المستخدم الحالي مع الطلبات الواردة
  Future<List<ProductModel>> getMyDonations() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase.from('products').select('''
        id,
        title,
        description,
        image_link,
        profiles!donor_id ( id, full_name, phone_number, address ),
        incoming_requests (
          id,
          requester_id,
          message,
          delivery_address,
          delivery_phone
        )
      ''').eq('donor_id', user.id).order('id', ascending: false);

      final rows = (response as List).cast<Map<String, dynamic>>();
      final requesterIds = rows
          .expand((item) =>
              (item['incoming_requests'] as List? ?? []).map((request) {
                return (request as Map<String, dynamic>)['requester_id']
                    ?.toString();
              }))
          .whereType<String>()
          .toSet()
          .toList();

      final Map<String, Map<String, dynamic>> profilesById = {};
      if (requesterIds.isNotEmpty) {
        final requesterIdsFilter = requesterIds.join(',');
        final profilesResponse = await _supabase
            .from('profiles')
            .select('id, full_name, phone_number, address')
            .filter('id', 'in', '($requesterIdsFilter)');
        for (final profile in (profilesResponse as List)) {
          final profileMap = profile as Map<String, dynamic>;
          final id = profileMap['id']?.toString();
          if (id != null) {
            profilesById[id] = profileMap;
          }
        }
      }

      return rows.map((item) {
        final requests = (item['incoming_requests'] as List?) ?? [];
        item['incoming_requests'] = requests.map((request) {
          final requestMap =
              Map<String, dynamic>.from(request as Map<String, dynamic>);
          final requesterId = requestMap['requester_id']?.toString();
          if (requesterId != null && profilesById.containsKey(requesterId)) {
            requestMap['profiles'] = profilesById[requesterId];
          }
          return requestMap;
        }).toList();
        return ProductModel.fromJson(item);
      }).toList();
    } catch (e) {
      print('Fetch My Products Error: $e');
      return [];
    }
  }

  // 3. حذف منتج
  Future<bool> deleteDonation(int productId) async {
    try {
      await _supabase
          .from('incoming_requests')
          .delete()
          .eq('product_id', productId);
      await _supabase.from('products').delete().eq('id', productId);
      return true;
    } catch (e) {
      print('Delete Product Error: $e');
      return false;
    }
  }

  // 4. إضافة منتج جديد
  Future<bool> createDonation({
    required String title,
    required String description,
    String? imageUrl,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('products').insert({
        'title': title,
        'description': description,
        'donor_id': user.id,
        'image_link': imageUrl,
      });
      return true;
    } catch (e) {
      print('Create Product Error: $e');
      return false;
    }
  }

  // 5. إرسال طلب وارد
  Future<bool> createDonationRequest({
    required int productId,
    required String fullName,
    required String phone,
    required String address,
    String? message,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('profiles').update({
        'full_name': fullName,
        'phone_number': phone,
        'address': address,
      }).eq('id', user.id);

      await _supabase.from('incoming_requests').insert({
        'product_id': productId,
        'requester_id': user.id,
        'delivery_address': address,
        'delivery_phone': phone,
        'message': message,
      });
      return true;
    } catch (e) {
      print('Create Request Error: $e');
      return false;
    }
  }
}
