import 'package:firebase_auth/firebase_auth.dart';
import '../interfaces/auth_service_interface.dart';

/// Firebase implementation of AuthServiceInterface
class FirebaseAuthService implements AuthServiceInterface {
  final FirebaseAuth _firebaseAuth;
  late final Stream<User?> _authStateChanges;

  FirebaseAuthService({FirebaseAuth? firebaseAuth}) 
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    // Create a broadcast stream that immediately emits the current user
    _authStateChanges = _firebaseAuth.authStateChanges().asBroadcastStream();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateChanges;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}