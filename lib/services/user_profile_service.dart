import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Auth accounts and Firestore profiles are separate. Repair a missing profile
/// on login without overwriting an existing profile or its administrator role.
class UserProfileService {
  static Future<void> ensure(User user, {String? name}) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection('users').doc(user.uid);
    final email = (user.email ?? '').toLowerCase();
    final isAdminEmail = email == 'admin@autogarage.com' || email.startsWith('admin@');

    await db.runTransaction((transaction) async {
      final existing = await transaction.get(ref);
      if (existing.exists) {
        // If it's an admin email, make sure role is admin
        if (isAdminEmail && existing.data()?['role'] != 'admin') {
          transaction.update(ref, {'role': 'admin'});
        }
        return;
      }

      transaction.set(ref, {
        'name': name ?? user.displayName ?? (isAdminEmail ? 'Admin Bengkel' : 'Pelanggan'),
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'address': '',
        'role': isAdminEmail ? 'admin' : 'user',
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
