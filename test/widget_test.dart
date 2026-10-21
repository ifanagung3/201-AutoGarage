import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/booking_draft.dart';

void main() {
  test('booking draft preserves each booking choice', () {
    final date = DateTime(2026, 10, 21);
    const serviceDraft = BookingDraft(serviceName: 'Tune Up');
    final dateDraft = serviceDraft.copyWith(bookingDate: date);
    final completedDraft = dateDraft.copyWith(bookingTime: '10:00');

    expect(completedDraft.serviceName, 'Tune Up');
    expect(completedDraft.bookingDate, date);
    expect(completedDraft.bookingTime, '10:00');
    expect(completedDraft.isComplete, isTrue);
  });
}
