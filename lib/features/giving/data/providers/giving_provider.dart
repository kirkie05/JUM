import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/services/payment_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/giving_model.dart';
import '../repositories/giving_repository.dart';

extension UserModelCurrencyExtension on UserModel {
  String get currency => email.contains('stripe') ? 'USD' : 'NGN';
}

class GivingNotifier extends StateNotifier<GivingState> {
  final Ref ref;

  GivingNotifier(this.ref) : super(const GivingState(
        selectedCategory: 'tithe',
        amount: 0.0,
        isRecurring: false,
        frequency: 'one_time',
        isLoading: false,
      ));

  void setCategory(String cat) => state = state.copyWith(selectedCategory: cat);
  void setAmount(double amt) => state = state.copyWith(amount: amt);
  void setRecurring(bool val) => state = state.copyWith(isRecurring: val);
  void setFrequency(String freq) => state = state.copyWith(frequency: freq);

  Future<bool> submitGiving(BuildContext context) async {
    if (state.amount <= 0) return false;
    state = state.copyWith(isLoading: true);
    
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'User not logged in');
        return false;
      }
      
      final ref_ = const Uuid().v4();
      final usePaystack = user.currency == 'NGN'; // detect from user profile extension
      
      bool success;
      if (usePaystack) {
        success = await ref.read(paymentServiceProvider).chargeWithPaystack(
              amount: state.amount,
              email: user.email,
              reference: ref_,
              context: context,
            );
      } else {
        success = await ref.read(paymentServiceProvider).chargeWithStripe(
              amount: state.amount,
              currency: 'usd',
              churchId: user.churchId,
            );
      }
      
      if (success) {
        final tx = GivingTransaction(
          id: const Uuid().v4(),
          userId: user.id,
          churchId: user.churchId,
          amount: state.amount,
          currency: usePaystack ? 'NGN' : 'USD',
          category: state.selectedCategory,
          gateway: usePaystack ? 'paystack' : 'stripe',
          reference: ref_,
          status: 'paid',
          createdAt: DateTime.now(),
        );
        
        await ref.read(givingRepositoryProvider).recordTransaction(tx);
        
        // Generate receipt URL
        final receiptUrl = await ref.read(givingRepositoryProvider).generateReceiptUrl(tx);
        final txWithReceipt = tx.copyWith(receiptUrl: receiptUrl);
        
        // Refresh giving history so it immediately updates
        ref.invalidate(givingHistoryProvider);
        
        // Navigate to receipt screen
        if (context.mounted) {
          context.push('/giving/receipt/${txWithReceipt.id}', extra: txWithReceipt);
        }
      }
      
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final givingNotifierProvider = StateNotifierProvider<GivingNotifier, GivingState>((ref) {
  return GivingNotifier(ref);
});

final givingHistoryProvider = FutureProvider<List<GivingTransaction>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Future.value([]);
  return ref.watch(givingRepositoryProvider).fetchHistory(user.id);
});
