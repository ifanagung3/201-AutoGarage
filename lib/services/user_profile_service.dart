import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Auth accounts and Firestore profiles are separate. Repair a missing profile
/// on login without overwriting an existing profile or its administrator role.
class UserProfileService {
  static Future<void> ensure(User user, {String? name}) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection('users').doc(user.uid);
    await db.runTransaction((transaction) async {
      final existing = await transaction.get(ref);
      if (existing.exists) return;
      transaction.set(ref, {
        'name': name ?? user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'address': '',
        'role': 'user',
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
