import 'vehicle_model.dart';

class BookingDraft {
  const BookingDraft({
    this.serviceName,
    this.serviceOption,
    this.bookingDate,
    this.bookingTime,
    this.vehicle,
  });

  final String? serviceName;
  final String? serviceOption;
  final DateTime? bookingDate;
  final String? bookingTime;
  final VehicleModel? vehicle;

  BookingDraft copyWith({
    String? serviceName,
    String? serviceOption,
    DateTime? bookingDate,
    String? bookingTime,
    VehicleModel? vehicle,
  }) {
    return BookingDraft(
      serviceName: serviceName ?? this.serviceName,
      serviceOption: serviceOption ?? this.serviceOption,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  bool get isComplete =>
      serviceName != null && bookingDate != null && bookingTime != null;
}
