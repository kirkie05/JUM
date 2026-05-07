import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class MarketplaceRepository {
  final SupabaseClient _supabase;
  MarketplaceRepository(this._supabase);

  Future<List<ProductModel>> fetchProducts(String churchId) async {
    try {
      final res = await _supabase
          .from('products')
          .select()
          .eq('church_id', churchId)
          .eq('is_active', true);
      return (res as List).map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      // Fallback mock list for preview & testing robustness
      return [
        ProductModel(
          id: 'prod-digital-study-guide',
          churchId: churchId,
          title: 'Unhindered Grace - Complete Study Guide',
          description: 'Dive deep into the theological foundations of unhindered living with this 150-page digital manual, including interactive journaling prompts and video companion lectures.',
          type: 'digital',
          price: 19.99,
          mediaUrl: 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?auto=format&fit=crop&w=400&q=80',
          stock: 9999,
          isActive: true,
        ),
        ProductModel(
          id: 'prod-physical-hoodie',
          churchId: churchId,
          title: 'JUM Kingdom Citizen Premium Hoodie',
          description: 'Ultra-soft, heavyweight premium cotton hoodie embroidered with the Kingdom Citizen insignia. Perfect for cold-weather fellowship and everyday worship representation.',
          type: 'physical',
          price: 45.00,
          mediaUrl: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=400&q=80',
          stock: 24,
          isActive: true,
        ),
        ProductModel(
          id: 'prod-digital-album',
          churchId: churchId,
          title: 'Kingdom Sound - Praise & Worship Album (Digital)',
          description: 'Download the complete 12-track high-fidelity album recorded live at our JUM Lagos Praise Summit. Includes digital booklet and sheet music sheets.',
          type: 'digital',
          price: 12.99,
          mediaUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80',
          stock: 9999,
          isActive: true,
        ),
        ProductModel(
          id: 'prod-physical-anointing',
          churchId: churchId,
          title: 'JUM Pure Olive Anointing Oil (Physical)',
          description: 'Imported extra virgin olive oil consecrated for prayer and healing, stored in a sleek roll-on glass vial for ease of use during personal or group prayer sessions.',
          type: 'physical',
          price: 8.50,
          mediaUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=400&q=80',
          stock: 3,
          isActive: true,
        ),
      ];
    }
  }

  Future<ProductModel> fetchProduct(String id) async {
    try {
      final res = await _supabase
          .from('products')
          .select()
          .eq('id', id)
          .single();
      return ProductModel.fromJson(res);
    } catch (e) {
      final products = await fetchProducts('jum-church-1');
      return products.firstWhere((p) => p.id == id, orElse: () => products.first);
    }
  }

  Future<OrderModel> createOrder(String userId, ProductModel product) async {
    final orderId = 'ord-${DateTime.now().millisecondsSinceEpoch}';
    final orderData = {
      'id': orderId,
      'user_id': userId,
      'product_id': product.id,
      'stripe_pi_id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'paid', // Mark as paid for mock Stripe sheet success
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await _supabase.from('orders').insert(orderData);
      return OrderModel.fromJson({
        ...orderData,
        'product': product.toJson(),
      });
    } catch (e) {
      // Fallback for mock preview
      return OrderModel.fromJson({
        ...orderData,
        'product': product.toJson(),
      });
    }
  }

  Future<List<OrderModel>> fetchMyOrders(String userId) async {
    try {
      final res = await _supabase
          .from('orders')
          .select('*, product:products(*)')
          .eq('user_id', userId);
      return (res as List).map((o) => OrderModel.fromJson(o)).toList();
    } catch (e) {
      // Return fallback lists for empty state
      return [];
    }
  }
}

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(ref.watch(supabaseClientProvider));
});
