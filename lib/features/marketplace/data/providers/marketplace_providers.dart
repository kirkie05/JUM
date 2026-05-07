import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../repositories/marketplace_repository.dart';

part 'marketplace_providers.g.dart';

@riverpod
Future<List<ProductModel>> products(ProductsRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  final churchId = currentUser?.churchId ?? 'jum-church-1';
  return ref.watch(marketplaceRepositoryProvider).fetchProducts(churchId);
}

@riverpod
Future<ProductModel> product(ProductRef ref, String id) {
  return ref.watch(marketplaceRepositoryProvider).fetchProduct(id);
}

@riverpod
Future<List<OrderModel>> myOrders(MyOrdersRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) return Future.value([]);
  return ref.watch(marketplaceRepositoryProvider).fetchMyOrders(currentUser.id);
}

@riverpod
class BuyProductNotifier extends _$BuyProductNotifier {
  @override
  FutureOr<void> build() {}

  Future<OrderModel?> buy(ProductModel product) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser == null) throw Exception('No user logged in');

      // Call the repository to create the order record (simulated / real Stripe backend checkout)
      final order = await ref.read(marketplaceRepositoryProvider).createOrder(currentUser.id, product);

      // Invalidate myOrders to trigger UI update
      ref.invalidate(myOrdersProvider);

      state = const AsyncValue.data(null);
      return order;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
