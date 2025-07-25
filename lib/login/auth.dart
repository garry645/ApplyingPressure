import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Auth? _instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Singleton pattern
  factory Auth() {
    _instance ??= Auth._internal();
    return _instance!;
  }
  
  Auth._internal();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
