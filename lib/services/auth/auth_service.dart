import 'package:starter_app/services/auth/auth_provider.dart';
import 'package:starter_app/services/auth/auth_user.dart';
import 'package:starter_app/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider _provider;

  const AuthService(this._provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => _provider.initialize();

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) {
    return _provider.createUser(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser {
    return _provider.currentUser;
  }

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) {
    return _provider.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() => _provider.logout();

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }
}
