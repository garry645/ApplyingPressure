import 'package:firebase_auth/firebase_auth.dart';

/// Abstract interface for authentication operations
abstract class AuthServiceInterface {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<void> sendPasswordResetEmail({required String email});
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}