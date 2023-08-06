import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:starter_app/firebase_options.dart';
import 'package:starter_app/services/auth/auth_provider.dart';
import 'package:starter_app/services/auth/auth_user.dart';
import 'package:starter_app/services/auth/auth_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException('User must be logged in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException(e.message ?? 'Unknown error');
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException(e.message ?? 'Unknown error');
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException(e.message ?? 'Unknown error');
      } else {
        throw UnknownAuthException(e.message ?? 'Unknown error');
      }
    } catch (_) {
      throw UnknownAuthException('Unknown error');
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException('User must be logged in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw UserNotFoundOrWrongPasswordAuthException;
      } else if (e.code == 'invalid-email') {
        throw UserNotFoundOrWrongPasswordAuthException;
      } else {
        throw UnknownAuthException(
            e.message ?? 'Unknown error occured in FirebaseAuth');
      }
    } catch (_) {
      throw UnknownAuthException(
          'Unknown error occured in FirebaseAuthProvider');
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException('User must be logged in');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }
}
