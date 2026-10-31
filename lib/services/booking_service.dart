import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/booking_model.dart';
import 'garage_diagnostics.dart';

class BookingService {
  static final BookingService instance = BookingService._internal();
  BookingService._internal()
      : _firestore = null,
        _firebaseAuth = null;

  BookingService.withDependencies({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _firebaseAuth = auth;

  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _firebaseAuth;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;
  FirebaseAuth get _auth => _firebaseAuth ?? FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Fetch user phone from Firestore profile (fallback to FirebaseAuth phone).
  Future<String> _getUserPhone(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      final phone = doc.data()?['phone'] as String?;
      if (phone != null && phone.trim().isNotEmpty) return phone.trim();
    } catch (_) {}
    return _auth.currentUser?.phoneNumber ?? '-';
  }

  /// Submit New Booking
  Future<String> createBooking({
    required String vehicleName,
    required String vehiclePlat,
    required int vehicleYear,
    required int vehicleKm,
    required String serviceName,
    String? serviceOption,
    required DateTime bookingDate,
    required String bookingTime,
    required double estimatedCost,
    String? notes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Pengguna harus masuk sebelum membuat booking.');
    }
    final uid = user.uid;
    final name = user.displayName ?? 'Pelanggan';
    // Fetch phone from Firestore so it is always up-to-date.
    final phone = await _getUserPhone(uid);

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
      serviceOption: serviceOption,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      estimatedCost: estimatedCost,
      status: 'Menunggu',
      currentStep: 1,
      totalSteps: 5,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await docRef.set(newBooking.toFirestore());
    return docRef.id;
  }

  /// Get Stream of Active Bookings for User
  Stream<List<BookingModel>> streamActiveBookings() {
    const activeStatuses = [
      'Menunggu',
      'Proses Pengecekan',
      'Sedang Dikerjakan',
      'Quality Check',
    ];
    return _streamCustomerBookings('active', activeStatuses);
  }

  /// Get Stream of Completed Booking History for User
  Stream<List<BookingModel>> streamBookingHistory() {
    const historyStatuses = ['Selesai', 'Dibatalkan'];
    return _streamCustomerBookings('history', historyStatuses);
  }

  Stream<List<BookingModel>> _streamCustomerBookings(
    String screen,
    List<String> statuses,
  ) async* {
    final uid = currentUserId;
    final watch = Stopwatch()..start();
    GarageDiagnostics.log('bookings.subscribe', {
      'screen': screen,
      'signedIn': uid != null,
    });
    if (uid == null) {
      GarageDiagnostics.log('bookings.noSession', {'screen': screen});
      yield [];
      return;
    }
    var received = false;
    final timer = GarageDiagnostics.enabled
        ? Timer(const Duration(seconds: 10), () {
            if (!received) {
              GarageDiagnostics.log('bookings.waiting',
                  {'screen': screen, 'elapsedMs': watch.elapsedMilliseconds});
            }
          })
        : null;
    try {
      await for (final snapshot in _db
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .snapshots(includeMetadataChanges: GarageDiagnostics.enabled)) {
        received = true;
        timer?.cancel();
        final all = <BookingModel>[];
        for (final doc in snapshot.docs) {
          try {
            all.add(BookingModel.fromFirestore(doc.data(), doc.id));
          } catch (error) {
            GarageDiagnostics.log('bookings.parseError', {
              'screen': screen,
              'type': error.runtimeType.toString(),
              'fieldTypes': {
                for (final field in [
                  'status',
                  'bookingDate',
                  'createdAt',
                  'estimatedCost',
                  'vehicleYear',
                  'vehicleKm',
                  'currentStep'
                ])
                  field: doc.data()[field]?.runtimeType.toString() ?? 'null',
              },
            });
            rethrow;
          }
        }
        final list = all.where((b) => statuses.contains(b.status)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        GarageDiagnostics.log('bookings.snapshot', {
          'screen': screen,
          'elapsedMs': watch.elapsedMilliseconds,
          'fromCache': snapshot.metadata.isFromCache,
          'pendingWrites': snapshot.metadata.hasPendingWrites,
          'documents': all.length,
          'visible': list.length,
          'sessionChanged': currentUserId != uid,
          'statusCounts': {
            for (final status in [
              'Menunggu',
              'Proses Pengecekan',
              'Sedang Dikerjakan',
              'Quality Check',
              'Selesai',
              'Dibatalkan'
            ])
              status: all.where((b) => b.status == status).length,
            'unknown': all
                .where((b) => ![
                      'Menunggu',
                      'Proses Pengecekan',
                      'Sedang Dikerjakan',
                      'Quality Check',
                      'Selesai',
                      'Dibatalkan'
                    ].contains(b.status))
                .length,
          },
        });
        yield list;
      }
    } catch (error) {
      GarageDiagnostics.log('bookings.error', {
        'screen': screen,
        'elapsedMs': watch.elapsedMilliseconds,
        'type': error.runtimeType.toString(),
        if (error is FirebaseException) 'code': error.code,
      });
      rethrow;
    } finally {
      timer?.cancel();
      GarageDiagnostics.log('bookings.cancel', {'screen': screen});
    }
  }

  /// Admin: Stream All Bookings with Pagination
  Stream<List<BookingModel>> streamAllBookings({int limit = 50}) {
    return _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /// Admin: Get Paginated Bookings (for load more functionality)
  Future<List<BookingModel>> getPaginatedBookings({
    required int limit,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _db
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => BookingModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateBookingStatus(
    String bookingId,
    String newStatus,
    int step,
  ) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': newStatus,
      'currentStep': step,
    });
  }

  /// Cancel Booking (User or Admin)
  Future<void> cancelBooking(String bookingId) async {
    final booking = await _db.collection('bookings').doc(bookingId).get();

    if (!booking.exists) {
      throw Exception('Booking not found');
    }

    final data = booking.data()!;
    final status = data['status'] as String?;

    if (status == 'Selesai') {
      throw Exception('Cannot cancel completed booking');
    }

    await _db.collection('bookings').doc(bookingId).update({
      'status': 'Dibatalkan',
      'currentStep': 0,
    });
  }

  /// Admin: Update Booking Details
  Future<void> updateBookingDetails({
    required String bookingId,
    String? vehicleName,
    String? vehiclePlat,
    int? vehicleYear,
    int? vehicleKm,
    String? serviceName,
    DateTime? bookingDate,
    String? bookingTime,
    double? estimatedCost,
    String? notes,
  }) async {
    final updates = <String, dynamic>{};

    if (vehicleName != null) updates['vehicleName'] = vehicleName;
    if (vehiclePlat != null) updates['vehiclePlat'] = vehiclePlat;
    if (vehicleYear != null) updates['vehicleYear'] = vehicleYear;
    if (vehicleKm != null) updates['vehicleKm'] = vehicleKm;
    if (serviceName != null) updates['serviceName'] = serviceName;
    if (bookingDate != null) {
      updates['bookingDate'] = Timestamp.fromDate(bookingDate);
    }
    if (bookingTime != null) updates['bookingTime'] = bookingTime;
    if (estimatedCost != null) updates['estimatedCost'] = estimatedCost;
    if (notes != null) updates['notes'] = notes;

    if (updates.isEmpty) return;

    await _db.collection('bookings').doc(bookingId).update(updates);
  }

  /// Admin: Patch userName and userPhone for a manually-created booking.
  /// Called right after createBooking() when an admin adds a walk-in customer.
  Future<void> patchManualBookingContact({
    required String bookingId,
    required String userName,
    required String userPhone,
  }) async {
    final updates = <String, dynamic>{};
    if (userName.isNotEmpty) updates['userName'] = userName;
    if (userPhone.isNotEmpty) updates['userPhone'] = userPhone;
    if (updates.isEmpty) return;
    await _db.collection('bookings').doc(bookingId).update(updates);
  }
}