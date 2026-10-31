import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/booking_draft.dart';
import 'package:auto_garage_201/models/vehicle_model.dart';

void main() {
  test('booking draft preserves each booking choice', () {
    final date = DateTime(2026, 10, 21);
    final vehicle = VehicleModel(
      id: 'vehicle-1',
      userId: 'user-1',
      brand: 'Toyota',
      model: 'Innova',
      platNumber: 'B 1234 ABC',
      year: 2020,
      kilometer: 50000,
    );
    final serviceDraft = BookingDraft(
      serviceName: 'Tuning ECU & Remap Stage 1 / 2',
      serviceOption: 'Stage 1',
      vehicle: vehicle,
    );
    final dateDraft = serviceDraft.copyWith(bookingDate: date);
    final completedDraft = dateDraft.copyWith(bookingTime: '10:00');

    expect(completedDraft.serviceName, 'Tuning ECU & Remap Stage 1 / 2');
    expect(completedDraft.serviceOption, 'Stage 1');
    expect(completedDraft.vehicle, same(vehicle));
    expect(completedDraft.bookingDate, date);
    expect(completedDraft.bookingTime, '10:00');
    expect(completedDraft.isComplete, isTrue);
  });
}
