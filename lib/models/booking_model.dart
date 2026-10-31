import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String vehicleName;
  final String vehiclePlat;
  final int vehicleYear;
  final int vehicleKm;
  final String serviceName;
  final String? serviceOption;
  final DateTime bookingDate;
  final String bookingTime;
  final double estimatedCost;
  final String
      status; // 'Menunggu', 'Proses Pengecekan', 'Sedang Dikerjakan', 'Quality Check', 'Selesai', 'Dibatalkan'
  final int currentStep;
  final int totalSteps;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.vehicleName,
    required this.vehiclePlat,
    required this.vehicleYear,
    required this.vehicleKm,
    required this.serviceName,
    this.serviceOption,
    required this.bookingDate,
    required this.bookingTime,
    required this.estimatedCost,
    required this.status,
    required this.currentStep,
    required this.totalSteps,
    this.notes,
    required this.createdAt,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BookingModel(
      id: docId,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      vehicleName: data['vehicleName'] ?? '',
      vehiclePlat: data['vehiclePlat'] ?? '',
      vehicleYear: data['vehicleYear'] ?? 2020,
      vehicleKm: data['vehicleKm'] ?? 10000,
      serviceName: data['serviceName'] ?? '',
      serviceOption: data['serviceOption'],
      bookingDate:
          (data['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bookingTime: data['bookingTime'] ?? '09:00',
      estimatedCost: (data['estimatedCost'] ?? 0).toDouble(),
      status: data['status'] ?? 'Menunggu',
      currentStep: data['currentStep'] ?? 1,
      totalSteps: data['totalSteps'] ?? 5,
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'vehicleName': vehicleName,
      'vehiclePlat': vehiclePlat,
      'vehicleYear': vehicleYear,
      'vehicleKm': vehicleKm,
      'serviceName': serviceName,
      if (serviceOption != null) 'serviceOption': serviceOption,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'bookingTime': bookingTime,
      'estimatedCost': estimatedCost,
      'status': status,
      'currentStep': currentStep,
      'totalSteps': totalSteps,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
