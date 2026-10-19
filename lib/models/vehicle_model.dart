class VehicleModel {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final String platNumber;
  final int year;
  final int kilometer;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.platNumber,
    required this.year,
    required this.kilometer,
  });

  String get fullName => '$brand $model ($year)';

  factory VehicleModel.fromMap(Map<String, dynamic> data, String id) {
    return VehicleModel(
      id: id,
      userId: data['userId'] ?? '',
      brand: data['brand'] ?? 'Toyota',
      model: data['model'] ?? 'Avanza',
      platNumber: data['platNumber'] ?? 'B 1234 AG',
      year: data['year'] ?? 2020,
      kilometer: data['kilometer'] ?? 35000,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'brand': brand,
      'model': model,
      'platNumber': platNumber,
      'year': year,
      'kilometer': kilometer,
    };
  }
}
