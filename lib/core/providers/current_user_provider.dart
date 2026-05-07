import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/models/user_model.dart';

part 'current_user_provider.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  AsyncValue<UserModel?> build() {
    return AsyncValue.data(UserModel(
      id: 'mock-user-id',
      clerkId: 'mock-clerk-id',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'member',
      churchId: 'jum-church-1',
      createdAt: DateTime.now(),
    ));
  }
}
