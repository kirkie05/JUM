import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/providers/auth_provider.dart';

part 'current_user_provider.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  AsyncValue<UserModel?> build() {
    return ref.watch(authNotifierProvider);
  }
}
