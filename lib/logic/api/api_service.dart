import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../models/donation_request.dart';

class ApiService {
  final _supabase = Supabase.instance.client;

  // 1. Fetch all available donations
  Future<List<ProductModel>?> getAllProducts({int maxRetries = 3}) async {
    try {
      final response = await _supabase.from('donations').select('''
        id,
        title,
        description,
        condition,
        status,
        created_at,
        images,
        profiles ( full_name ),
        categories ( name )
      ''').order('created_at', ascending: false);

      final List<ProductModel> products = (response as List).map((item) {
        final images = item['images'] as List?;
        final image = (images != null && images.isNotEmpty) 
            ? images.first 
            : 'http://www.shutterstock.com/image-vector/mystery-contest-cardboard-box-question-260nw-2472419999.jpg';
        
        final profiles = item['profiles'] as Map<String, dynamic>?;
        final donorName = profiles?['full_name'] ?? 'متبرع مجهول';
        
        final categories = item['categories'] as Map<String, dynamic>?;
        final category = categories?['name'] ?? 'أخرى';

        return ProductModel(
          id: item['id'] ?? 0,
          title: item['title'] ?? 'بدون عنوان',
          description: item['description'] ?? 'لا يوجد وصف',
          category: category,
          image: image,
          donorName: donorName,
          condition: item['condition'] ?? 'مستعمل جيد',
          isAvailable: item['status'] == 'متاح',
          createdAt: item['created_at'] ?? '',
        );
      }).toList();

      if (products.isNotEmpty) {
        return products;
      } else {
        return [];
      }
    } catch (e) {
      print('Supabase Fetch Error: $e');
      return [];
    }
  }

  // 2. Fetch user's own donations with incoming requests
  Future<List<ProductModel>> getMyDonations() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase.from('donations').select('''
        id,
        title,
        description,
        condition,
        status,
        created_at,
        images,
        profiles!donor_id ( full_name ),
        categories ( name ),
        donation_requests (
          id,
          message,
          delivery_address,
          delivery_phone,
          status,
          created_at,
          profiles!requester_id ( full_name )
        )
      ''').eq('donor_id', user.id).order('created_at', ascending: false);


      return (response as List).map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    } catch (e) {
      print('Fetch My Donations Error: $e');
      return [];
    }
  }

  // Accept or Reject Request
  Future<bool> updateRequestStatus(int requestId, String newStatus) async {
    try {
      await _supabase.from('donation_requests').update({'status': newStatus}).eq('id', requestId);
      return true;
    } catch (e) {
      print('Update Request Error: $e');
      return false;
    }
  }

  // 3. Create a new donation
  Future<bool> createDonation({
    required String title,
    required String description,
    required String categoryName,
    required String condition,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Get category id
      final categoryRes = await _supabase
          .from('categories')
          .select('id')
          .eq('name', categoryName)
          .maybeSingle();
      
      final categoryId = categoryRes?['id'];

      await _supabase.from('donations').insert({
        'title': title,
        'description': description,
        'category_id': categoryId,
        'donor_id': user.id,
        'condition': condition,
        'status': 'متاح',
      });
      return true;
    } catch (e) {
      print('Create Donation Error: $e');
      return false;
    }
  }

  // 4. Create donation requests
  Future<bool> createDonationRequests({
    required List<DonationRequest> requests,
    required String fullName,
    required String phone,
    required String address,
    String? message,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Update user profile with delivery info if needed
      await _supabase.from('profiles').update({
        'full_name': fullName,
        'phone_number': phone,
        'address': address,
      }).eq('id', user.id);

      // Insert all requests
      final requestsData = requests.map((req) => {
        'donation_id': req.product.id,
        'requester_id': user.id,
        'delivery_address': address,
        'delivery_phone': phone,
        'message': message,
      }).toList();

      await _supabase.from('donation_requests').insert(requestsData);
      return true;
    } catch (e) {
      print('Create Request Error: $e');
      return false;
    }
  }
}
