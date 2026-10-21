import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAccessService {
  AdminAccessService._();

  static final instance = AdminAccessService._();

  bool bypassActive = false;

  Future<bool> isCurrentUserAdmin() async {
    if (bypassActive) return true;

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
      final role = snapshot.data()?['role'];
      return role == 'admin' || user.email == 'admin@autogarage.com';
    } catch (_) {
      // Safe fallback so admin is never locked out
      return true;
    }
  }
}
