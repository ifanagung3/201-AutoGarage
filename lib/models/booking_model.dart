import 'package:cloud_firestore/cloud_firestore.dart';

class BookingStatusLog {
  final String status;
  final String updatedBy;
  final DateTime timestamp;

  BookingStatusLog({
    required this.status,
    required this.updatedBy,
    required this.timestamp,
  });

  factory BookingStatusLog.fromMap(Map<String, dynamic> map) {
    return BookingStatusLog(
      status: map['status'] ?? '',
      updatedBy: map['updatedBy'] ?? 'System',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'updatedBy': updatedBy,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

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
  final DateTime bookingDate;
  final String bookingTime;
  final double estimatedCost;
  final String status; // 'Menunggu', 'Proses Pengecekan', 'Sedang Dikerjakan', 'Quality Check', 'Selesai', 'Dibatalkan'
  final int currentStep;
  final int totalSteps;
  final String? notes;
  final List<BookingStatusLog> statusHistory;
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
    required this.bookingDate,
    required this.bookingTime,
    required this.estimatedCost,
    required this.status,
    required this.currentStep,
    required this.totalSteps,
    this.notes,
    required this.statusHistory,
    required this.createdAt,
  });

  factory BookingModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final rawHistory = data['statusHistory'] as List<dynamic>? ?? [];
    final logs = rawHistory.map((item) => BookingStatusLog.fromMap(Map<String, dynamic>.from(item))).toList();

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
      bookingDate: (data['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bookingTime: data['bookingTime'] ?? '09:00',
      estimatedCost: (data['estimatedCost'] ?? 0).toDouble(),
      status: data['status'] ?? 'Menunggu',
      currentStep: data['currentStep'] ?? 1,
      totalSteps: data['totalSteps'] ?? 5,
      notes: data['notes'],
      statusHistory: logs,
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
      'bookingDate': Timestamp.fromDate(bookingDate),
      'bookingTime': bookingTime,
      'estimatedCost': estimatedCost,
      'status': status,
      'currentStep': currentStep,
      'totalSteps': totalSteps,
      'notes': notes,
      'statusHistory': statusHistory.map((log) => log.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
