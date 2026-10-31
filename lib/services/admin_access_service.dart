import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminAccessService {
  AdminAccessService._();
  static final instance = AdminAccessService._();

  Future<bool> isCurrentUserAdmin() async {
    if (Firebase.apps.isEmpty) return false;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(const GetOptions(source: Source.server));
      return FirebaseAuth.instance.currentUser?.uid == user.uid &&
          snapshot.data()?['role'] == 'admin';
    } catch (error, stackTrace) {
      developer.log(
        'Admin access check failed; denying access',
        name: 'AdminAccessService',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
