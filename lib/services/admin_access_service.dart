import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAccessService {
  AdminAccessService._();
  static final instance = AdminAccessService._();

  Future<bool> isCurrentUserAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .get(const GetOptions(source: Source.server));
      return FirebaseAuth.instance.currentUser?.uid == user.uid &&
          snapshot.data()?['role'] == 'admin';
    } on FirebaseException {
      return false;
    }
  }
}
