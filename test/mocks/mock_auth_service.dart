import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:applying_pressure/services/interfaces/auth_service_interface.dart';

class MockAuthService implements AuthServiceInterface {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();
  
  // Allow tests to set the current user
  void setCurrentUser(User? user) {
    _currentUser = user;
    _authStateController.add(user);
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    // Mock implementation - do nothing or throw if email is invalid
    if (!email.contains('@')) {
      throw FirebaseAuthException(code: 'invalid-email');
    }
  }

  @override
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Mock successful login
    if (email == 'test@example.com' && password == 'password123') {
      final mockUser = MockUser(email: email);
      setCurrentUser(mockUser);
      return true;
    }
    // Mock failed login
    throw FirebaseAuthException(code: 'wrong-password');
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Mock user creation
    if (email.contains('@') && password.length >= 6) {
      final mockUser = MockUser(email: email);
      setCurrentUser(mockUser);
    } else {
      throw FirebaseAuthException(code: 'weak-password');
    }
  }

  @override
  Future<void> signOut() async {
    setCurrentUser(null);
  }
  
  void dispose() {
    _authStateController.close();
  }
}

class MockUser extends Mock implements User {
  final String _email;
  final String _uid;
  
  MockUser({required String email, String? uid}) 
    : _email = email,
      _uid = uid ?? email.hashCode.toString();
  
  @override
  String? get email => _email;
  
  @override
  String get uid => _uid;
  
  @override
  bool get emailVerified => true;
  
  @override
  String? get displayName => 'Test User';
}

class MockFirebaseAuthException extends Mock implements FirebaseAuthException {
  @override
  final String code;
  
  MockFirebaseAuthException({required this.code});
}