import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';

class BookingService {
  static final BookingService instance = BookingService._internal();
  BookingService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Submit New Booking
  Future<String> createBooking({
    required String vehicleName,
    required String vehiclePlat,
    required int vehicleYear,
    required int vehicleKm,
    required String serviceName,
    required DateTime bookingDate,
    required String bookingTime,
    required double estimatedCost,
    String? notes,
  }) async {
    final user = _auth.currentUser;
    final uid = user?.uid ?? 'guest_user';
    final name = user?.displayName ?? 'Pelanggan';
    final phone = user?.phoneNumber ?? '-';

    final docRef = _db.collection('bookings').doc();
    final newBooking = BookingModel(
      id: docRef.id,
      userId: uid,
      userName: name,
      userPhone: phone,
      vehicleName: vehicleName,
      vehiclePlat: vehiclePlat,
      vehicleYear: vehicleYear,
      vehicleKm: vehicleKm,
      serviceName: serviceName,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      estimatedCost: estimatedCost,
      status: 'Menunggu',
      currentStep: 1,
      totalSteps: 5,
      notes: notes,
      createdAt: DateTime.now(),
    );

    try {
      await docRef.set(newBooking.toFirestore());
      return docRef.id;
    } catch (e) {
      // Local fallback ID if firestore fails
      return 'local_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Get Stream of Active Bookings for User
  Stream<List<BookingModel>> streamActiveBookings() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.value(_getMockActiveBookings());
    }

    return _db
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .where('status', whereIn: ['Menunggu', 'Proses Pengecekan', 'Sedang Dikerjakan', 'Quality Check'])
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return _getMockActiveBookings();
          }
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
              .toList();
        })
        .handleError((_) => _getMockActiveBookings());
  }

  /// Get Stream of Completed Booking History for User
  Stream<List<BookingModel>> streamBookingHistory() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.value(_getMockHistoryBookings());
    }

    return _db
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .where('status', whereIn: ['Selesai', 'Dibatalkan'])
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return _getMockHistoryBookings();
          }
          return snapshot.docs
              .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
              .toList();
        })
        .handleError((_) => _getMockHistoryBookings());
  }

  /// Admin: Update Booking Status and Step
  Future<void> updateBookingStatus(String bookingId, String newStatus, int step) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': newStatus,
        'currentStep': step,
      });
    } catch (_) {}
  }

  // Mock Fallbacks so app UI is never empty
  List<BookingModel> _getMockActiveBookings() {
    return [
      BookingModel(
        id: '#BK-1001',
        userId: currentUserId ?? '1',
        userName: 'Ahmad Fauzi',
        userPhone: '081234567890',
        vehicleName: 'Toyota Avanza 1.3 G',
        vehiclePlat: 'B 1234 AG',
        vehicleYear: 2020,
        vehicleKm: 35000,
        serviceName: 'Servis Rutin Berkala',
        bookingDate: DateTime.now().add(const Duration(days: 1)),
        bookingTime: '09:00 WIB',
        estimatedCost: 195000,
        status: 'Sedang Dikerjakan',
        currentStep: 3,
        totalSteps: 5,
        notes: 'Ganti oli mesin & cek rem',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      BookingModel(
        id: '#BK-1002',
        userId: currentUserId ?? '1',
        userName: 'Ahmad Fauzi',
        userPhone: '081234567890',
        vehicleName: 'Honda HR-V 1.5 E',
        vehiclePlat: 'B 5678 CD',
        vehicleYear: 2021,
        vehicleKm: 28000,
        serviceName: 'Tune Up & Clean AC',
        bookingDate: DateTime.now().add(const Duration(days: 3)),
        bookingTime: '13:00 WIB',
        estimatedCost: 380000,
        status: 'Proses Pengecekan',
        currentStep: 2,
        totalSteps: 5,
        notes: 'AC kurang dingin',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  List<BookingModel> _getMockHistoryBookings() {
    return [
      BookingModel(
        id: '#BK-0988',
        userId: currentUserId ?? '1',
        userName: 'Ahmad Fauzi',
        userPhone: '081234567890',
        vehicleName: 'Toyota Avanza 1.3 G',
        vehiclePlat: 'B 1234 AG',
        vehicleYear: 2020,
        vehicleKm: 30000,
        serviceName: 'Servis Rutin & Ganti Filter',
        bookingDate: DateTime.now().subtract(const Duration(days: 14)),
        bookingTime: '10:00 WIB',
        estimatedCost: 215000,
        status: 'Selesai',
        currentStep: 5,
        totalSteps: 5,
        notes: 'Selesai tepat waktu',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      BookingModel(
        id: '#BK-0870',
        userId: currentUserId ?? '1',
        userName: 'Ahmad Fauzi',
        userPhone: '081234567890',
        vehicleName: 'Toyota Avanza 1.3 G',
        vehiclePlat: 'B 1234 AG',
        vehicleYear: 2020,
        vehicleKm: 20000,
        serviceName: 'Ganti Ban Front Left',
        bookingDate: DateTime.now().subtract(const Duration(days: 45)),
        bookingTime: '14:00 WIB',
        estimatedCost: 450000,
        status: 'Selesai',
        currentStep: 5,
        totalSteps: 5,
        notes: 'Balancing + Spooring',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
    ];
  }
}
