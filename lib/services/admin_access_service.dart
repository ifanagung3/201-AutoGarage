import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAccessService {
  AdminAccessService._();
  static final instance = AdminAccessService._();

  Future<bool> isCurrentUserAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final email = (user.email ?? '').toLowerCase();
    final isAdminEmail = email == 'admin@autogarage.com' || email.startsWith('admin@');

    if (isAdminEmail) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'role': 'admin',
          'email': user.email,
        }, SetOptions(merge: true));
      } catch (_) {}
      return true;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .get(const GetOptions(source: Source.server));
      return snapshot.data()?['role'] == 'admin';
    } catch (_) {
      return isAdminEmail;
    }
  }
}
