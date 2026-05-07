class ClerkEmailAddress {
  final String emailAddress;
  const ClerkEmailAddress(this.emailAddress);
}

class User {
  final String id;
  final String? firstName;
  final String? lastName;
  final List<ClerkEmailAddress> emailAddresses;
  final Map<String, dynamic> publicMetadata;

  const User({
    required this.id,
    this.firstName,
    this.lastName,
    this.emailAddresses = const [],
    this.publicMetadata = const {},
  });
}

enum Strategy {
  emailCode,
}

class Clerk {
  Clerk._();
  static final Clerk instance = Clerk._();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> signIn({
    required Strategy strategy,
    required String identifier,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = User(
      id: 'mock-clerk-user-id',
      firstName: 'John',
      lastName: 'Doe',
      emailAddresses: [ClerkEmailAddress(identifier)],
      publicMetadata: {'role': 'member'},
    );
  }

  Future<User?> verifySignIn({required String code}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String emailAddress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = User(
      id: 'mock-clerk-user-id',
      firstName: firstName,
      lastName: lastName,
      emailAddresses: [ClerkEmailAddress(emailAddress)],
      publicMetadata: {'role': 'member'},
    );
  }

  Future<User?> verifySignUp({required String code}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  Future<void> signOut() async {
    _currentUser = null;
  }
}
