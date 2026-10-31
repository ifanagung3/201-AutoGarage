// In-memory SDK test doubles only; never used by the application.
// ignore_for_file: subtype_of_sealed_class, must_be_immutable

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_garage_201/services/user_profile_service.dart';

class TestUser extends Fake implements User {
  @override
  String get uid => 'customer-uid';
  @override
  String get email => 'admin@example.com';
  @override
  String get displayName => 'Pelanggan';
  @override
  String? get phoneNumber => null;
}

class ProfileSnapshot<T> extends Fake implements DocumentSnapshot<T> {
  ProfileSnapshot(this.value);
  final T? value;
  @override
  bool get exists => value != null;
  @override
  T? data() => value;
}

class ProfileRef extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

class Profiles extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  String? documentId;
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    documentId = path;
    return ProfileRef();
  }
}

class ProfileTransaction extends Fake implements Transaction {
  Map<String, dynamic>? value;
  Object? failure;
  int writes = 0;
  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
      DocumentReference<T> ref) async {
    if (failure != null) throw failure!;
    return ProfileSnapshot<T>(value as T?);
  }

  @override
  Transaction set<T>(DocumentReference<T> ref, T data, [SetOptions? options]) {
    writes++;
    value = Map<String, dynamic>.from(data as Map);
    return this;
  }
}

class ProfileDatabase extends Fake implements FirebaseFirestore {
  final profiles = Profiles();
  final transaction = ProfileTransaction();
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    expect(path, 'users');
    return profiles;
  }

  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> handler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) =>
      handler(transaction);
}

void main() {
  test('missing profile uses auth uid and never promotes admin-prefixed email',
      () async {
    final db = ProfileDatabase();
    await UserProfileService.ensure(TestUser(),
        name: 'Nama Baru', firestore: db);
    expect(db.profiles.documentId, 'customer-uid');
    expect(db.transaction.value?['name'], 'Nama Baru');
    expect(db.transaction.value?['email'], 'admin@example.com');
    expect(db.transaction.value?['role'], 'user');
    expect(db.transaction.value?['createdAt'], isA<FieldValue>());
  });

  for (final role in ['user', 'customer', 'admin']) {
    test('existing $role profile is preserved and repeated login is idempotent',
        () async {
      final db = ProfileDatabase();
      final original = {
        'role': role,
        'name': 'Nama Tersimpan',
        'phone': '08123'
      };
      db.transaction.value = Map.of(original);
      await UserProfileService.ensure(TestUser(),
          name: 'Jangan timpa', firestore: db);
      await UserProfileService.ensure(TestUser(), firestore: db);
      expect(db.transaction.value, original);
      expect(db.transaction.writes, 0);
    });
  }

  test('failed profile synchronization is not swallowed', () async {
    final db = ProfileDatabase();
    db.transaction.failure =
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied');
    await expectLater(UserProfileService.ensure(TestUser(), firestore: db),
        throwsA(isA<FirebaseException>()));
    expect(db.transaction.writes, 0);
  });
}
