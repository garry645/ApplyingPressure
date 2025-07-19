import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Firebase Core Mocks
class MockFirebaseApp extends Mock implements FirebaseApp {}

// Firebase Auth Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

// Firestore Mocks
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference<T> extends Mock implements CollectionReference<T> {}
class MockDocumentReference<T> extends Mock implements DocumentReference<T> {}
class MockDocumentSnapshot<T> extends Mock implements DocumentSnapshot<T> {}
class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {}
class MockQueryDocumentSnapshot<T> extends Mock implements QueryDocumentSnapshot<T> {}
class MockQuery<T> extends Mock implements Query<T> {}

// Firebase Storage Mocks
class MockFirebaseStorage extends Mock implements FirebaseStorage {}
class MockReference extends Mock implements Reference {}
class MockUploadTask extends Mock implements UploadTask {}
class MockTaskSnapshot extends Mock implements TaskSnapshot {}

// Setup function to initialize Firebase mocks
void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Firebase#initializeCore':
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test-api-key',
              'appId': 'test-app-id',
              'messagingSenderId': 'test-sender-id',
              'projectId': 'test-project-id',
            },
            'pluginConstants': {},
          }
        ];
      case 'Firebase#initializeApp':
        return {
          'name': methodCall.arguments['appName'],
          'options': methodCall.arguments['options'],
          'pluginConstants': {},
        };
      default:
        return null;
    }
    },
  );
}

// Setup function for Firestore mocks
void setupFirestoreMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_firestore'),
    (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Firestore#GetOptions':
        return {};
      default:
        return null;
    }
    },
  );
}

// Setup function for Auth mocks
void setupFirebaseAuthMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_auth'),
    (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Auth#registerIdTokenListener':
        return {};
      case 'Auth#registerAuthStateListener':
        return {};
      default:
        return null;
    }
    },
  );
}

// Setup all Firebase mocks
void setupFirebaseMocks() {
  setupFirebaseCoreMocks();
  setupFirestoreMocks();
  setupFirebaseAuthMocks();
}

// Test doubles for services
class FakeFirebaseFirestore extends Fake implements FirebaseFirestore {
  final _collections = <String, FakeCollectionReference>{};

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    _collections[collectionPath] ??= FakeCollectionReference(collectionPath);
    return _collections[collectionPath]!;
  }

  Settings _settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  @override
  Settings get settings => _settings;

  @override
  set settings(Settings value) {
    _settings = value;
  }
}

class FakeCollectionReference extends Fake implements CollectionReference<Map<String, dynamic>> {
  final String path;
  final List<Map<String, dynamic>> _documents = [];
  
  FakeCollectionReference(this.path);

  @override
  String get id => path.split('/').last;

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(Map<String, dynamic> data) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _documents.add({...data, 'id': id});
    return FakeDocumentReference(id, data);
  }

  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    final docId = path ?? DateTime.now().millisecondsSinceEpoch.toString();
    return FakeDocumentReference(docId, {});
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
  }) {
    return Stream.value(FakeQuerySnapshot(_documents));
  }

  @override
  Query<Map<String, dynamic>> orderBy(
    Object field, {
    bool descending = false,
  }) {
    return this;
  }
}

class FakeDocumentReference extends Fake implements DocumentReference<Map<String, dynamic>> {
  final String docId;
  Map<String, dynamic> _data;

  FakeDocumentReference(this.docId, this._data);

  @override
  String get id => docId;

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    _data = data;
  }

  @override
  Future<void> update(Map<Object, Object?> data) async {
    _data.addAll(data.cast<String, Object?>());
  }

  @override
  Future<void> delete() async {
    _data = {};
  }
}

class FakeQuerySnapshot extends Fake implements QuerySnapshot<Map<String, dynamic>> {
  final List<Map<String, dynamic>> documents;

  FakeQuerySnapshot(this.documents);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs {
    return documents
        .map((doc) => FakeQueryDocumentSnapshot(doc))
        .toList();
  }

  @override
  List<DocumentChange<Map<String, dynamic>>> get docChanges => [];

  @override
  int get size => documents.length;
}

class FakeQueryDocumentSnapshot extends Fake implements QueryDocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;

  FakeQueryDocumentSnapshot(this._data);

  @override
  String get id => _data['id'] ?? '';

  @override
  Map<String, dynamic> data() => _data;

  @override
  bool get exists => true;
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> authStateChanges() => _authStateController.stream;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _currentUser = FakeUser(email);
    _authStateController.add(_currentUser);
    return FakeUserCredential(_currentUser!);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}

class FakeUser extends Fake implements User {
  final String _email;

  FakeUser(this._email);

  @override
  String? get email => _email;

  @override
  String get uid => _email.hashCode.toString();

  @override
  bool get emailVerified => true;

  @override
  String? get displayName => 'Test User';
}

class FakeUserCredential extends Fake implements UserCredential {
  final User _user;

  FakeUserCredential(this._user);

  @override
  User get user => _user;
}