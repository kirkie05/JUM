import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class MarketplaceRepository {
  final SupabaseClient _supabase;
  MarketplaceRepository(this._supabase);

  Future<List<ProductModel>> fetchProducts() async {
    final res = await _supabase
        .from('products')
        .select()
        .eq('is_active', true);
    return (res as List).map((p) => ProductModel.fromJson(p)).toList();
  }

  Future<ProductModel> fetchProduct(String id) async {
    final res = await _supabase
        .from('products')
        .select()
        .eq('id', id)
        .single();
    return ProductModel.fromJson(res);
  }

  Future<OrderModel> createOrder(String userId, ProductModel product) async {
    // Generate order UUID from Supabase rather than trusting client-side timestamps
    // or we can let Supabase generate it and return it via .select()
    
    final orderData = {
      'user_id': userId,
      'product_id': product.id,
      'stripe_pi_id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}', // Will be replaced by actual Stripe integration
      'status': 'paid',
    };

    final res = await _supabase.from('orders').insert(orderData).select().single();
    
    return OrderModel.fromJson({
      ...res,
      'product': product.toJson(),
    });
  }

  Future<List<OrderModel>> fetchMyOrders(String userId) async {
    final res = await _supabase
        .from('orders')
        .select('*, product:products(*)')
        .eq('user_id', userId);
    return (res as List).map((o) => OrderModel.fromJson(o)).toList();
  }
}

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(ref.watch(supabaseClientProvider));
});
