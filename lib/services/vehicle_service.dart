import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  static final VehicleService instance = VehicleService._internal();
  VehicleService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream of Vehicles for Current User
  Stream<List<VehicleModel>> streamUserVehicles() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('vehicles')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => VehicleModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.year.compareTo(a.year));
      return list;
    });
  }

  /// Add New Vehicle
  Future<String> addVehicle({
    required String brand,
    required String model,
    required String platNumber,
    required int year,
    required int kilometer,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User belum terautentikasi');

    final docRef = _db.collection('vehicles').doc();
    final vehicle = VehicleModel(
      id: docRef.id,
      userId: uid,
      brand: brand,
      model: model,
      platNumber: platNumber,
      year: year,
      kilometer: kilometer,
    );

    await docRef.set(vehicle.toMap());
    return docRef.id;
  }

  /// Update Vehicle
  Future<void> updateVehicle({
    required String vehicleId,
    required String brand,
    required String model,
    required String platNumber,
    required int year,
    required int kilometer,
  }) async {
    await _db.collection('vehicles').doc(vehicleId).update({
      'brand': brand,
      'model': model,
      'platNumber': platNumber,
      'year': year,
      'kilometer': kilometer,
    });
  }

  /// Delete Vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    await _db.collection('vehicles').doc(vehicleId).delete();
  }
}
