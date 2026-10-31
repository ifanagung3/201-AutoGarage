// In-memory Firebase test doubles; no Firebase app or network is required.
// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/services/booking_service.dart';

class _TestAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class _TestFirestore extends Fake implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _TestCollection();
}

class _TestCollection extends Fake
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) =>
      _TestDocument();
}

class _TestDocument extends Fake
    implements DocumentReference<Map<String, dynamic>> {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) =>
      Future.value(_TestSnapshot());
}

class _TestSnapshot extends Fake
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  bool get exists => false;

  @override
  Map<String, dynamic>? data() => null;
}

void main() {
  BookingService createService() => BookingService.withDependencies(
        firestore: _TestFirestore(),
        auth: _TestAuth(),
      );

  group('BookingService', () {
    test('instance is a singleton', () {
      expect(BookingService.instance, same(BookingService.instance));
    });

    test('currentUserId returns null when not authenticated', () {
      expect(createService().currentUserId, isNull);
    });

    test('active bookings are empty when not authenticated', () async {
      expect(await createService().streamActiveBookings().first, isEmpty);
    });

    test('booking history is empty when not authenticated', () async {
      expect(await createService().streamBookingHistory().first, isEmpty);
    });

    test('createBooking rejects unauthenticated users', () async {
      await expectLater(
        createService().createBooking(
          vehicleName: 'Toyota Avanza',
          vehiclePlat: 'B 1234 ABC',
          vehicleYear: 2020,
          vehicleKm: 50000,
          serviceName: 'Servis Rutin',
          bookingDate: DateTime(2026, 10, 24),
          bookingTime: '10:00',
          estimatedCost: 250000,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('cancelBooking rejects a non-existent booking', () async {
      await expectLater(
        createService().cancelBooking('non_existent_id'),
        throwsA(isA<Exception>()),
      );
    });

    test('empty booking updates complete without Firestore access', () async {
      await expectLater(
        createService().updateBookingDetails(bookingId: 'test_id'),
        completes,
      );
    });
  });
}
