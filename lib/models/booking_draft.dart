class BookingDraft {
  const BookingDraft({
    this.serviceName,
    this.bookingDate,
    this.bookingTime,
  });

  final String? serviceName;
  final DateTime? bookingDate;
  final String? bookingTime;

  BookingDraft copyWith({
    String? serviceName,
    DateTime? bookingDate,
    String? bookingTime,
  }) {
    return BookingDraft(
      serviceName: serviceName ?? this.serviceName,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
    );
  }

  bool get isComplete =>
      serviceName != null && bookingDate != null && bookingTime != null;
}
