import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAccessService {
  AdminAccessService._();

  static final instance = AdminAccessService._();

  Future<bool> isCurrentUserAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    // Direct check for admin email address
    if (user.email == 'admin@autogarage.com' ||
        (user.email != null && user.email!.toLowerCase().startsWith('admin@'))) {
      return true;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return snapshot.data()?['role'] == 'admin';
    } catch (_) {
      return user.email == 'admin@autogarage.com' ||
          (user.email != null && user.email!.toLowerCase().startsWith('admin@'));
    }
  }
}
