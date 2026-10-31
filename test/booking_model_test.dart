import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/booking_model.dart';

void main() {
  test('booking model persists optional service choice', () {
    final booking = BookingModel(
      id: 'booking-1',
      userId: 'user-1',
      userName: 'Budi',
      userPhone: '08123456789',
      vehicleName: 'Toyota Innova',
      vehiclePlat: 'B 1234 ABC',
      vehicleYear: 2020,
      vehicleKm: 50000,
      serviceName: 'Tuning ECU & Remap Stage 1 / 2',
      serviceOption: 'Stage 2',
      bookingDate: DateTime(2026, 10, 24),
      bookingTime: '10:00 WIB',
      estimatedCost: 800000,
      status: 'Menunggu',
      currentStep: 1,
      totalSteps: 5,
      createdAt: DateTime(2026, 10, 20),
    );

    final restored = BookingModel.fromFirestore(
      booking.toFirestore(),
      booking.id,
    );

    expect(restored.serviceOption, 'Stage 2');
    expect(restored.serviceName, booking.serviceName);
    expect(restored.vehicleName, booking.vehicleName);
    expect(restored.vehiclePlat, booking.vehiclePlat);
  });

  test('older booking records without an option remain supported', () {
    final data = {
      'bookingDate': Timestamp.fromDate(DateTime(2026, 10, 24)),
      'createdAt': Timestamp.fromDate(DateTime(2026, 10, 20)),
    };

    final booking = BookingModel.fromFirestore(data, 'booking-legacy');

    expect(booking.serviceOption, isNull);
  });
}
