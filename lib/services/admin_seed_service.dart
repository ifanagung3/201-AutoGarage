import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSeedService {
  static final AdminSeedService instance = AdminSeedService._internal();
  AdminSeedService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Set User Role to Admin in Firestore
  Future<void> setUserAsAdmin(String uid) async {
    try {
      await _db.collection('users').doc(uid).set({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  /// Seed Default Firestore Data (Services & Promos) if empty
  Future<void> seedDefaultData() async {
    try {
      // 1. Seed Services Catalog
      final serviceSnapshot = await _db.collection('services').get();
      if (serviceSnapshot.docs.isEmpty) {
        final defaultServices = [
          {'name': 'Servis Rutin Berkala', 'description': 'Ganti oli, filter, dan pemeriksaan umum 20 titik', 'basePrice': 150000},
          {'name': 'Tune Up Mesin', 'description': 'Pembersihan injector, pembersihan throttle body & ganti busi', 'basePrice': 300000},
          {'name': 'AC Service', 'description': 'Pembersihan evaporator, penggantian oli kompresor & isi freon', 'basePrice': 200000},
          {'name': 'Ganti Ban & Balancing', 'description': 'Ganti ban baru, balancing, dan spooring 4 roda', 'basePrice': 400000},
        ];

        for (var s in defaultServices) {
          await _db.collection('services').add({
            ...s,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      // 2. Seed Promos
      final promoSnapshot = await _db.collection('promos').get();
      if (promoSnapshot.docs.isEmpty) {
        final defaultPromos = [
          {'title': 'Diskon 20% Servis Rutin', 'code': 'SERVIS20', 'discount': '20%', 'isActive': true},
          {'title': 'Gratis Cuci Mobil', 'code': 'CUCIGRATIS', 'discount': '100%', 'isActive': true},
          {'title': 'Diskon 10% Tune Up', 'code': 'TUNEUP10', 'discount': '10%', 'isActive': true},
        ];

        for (var p in defaultPromos) {
          await _db.collection('promos').add({
            ...p,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {}
  }
}
