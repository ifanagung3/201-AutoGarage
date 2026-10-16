class ServiceEstimationInput {
  final String category; // 'Servis Rutin', 'Tune Up', 'AC Service', 'Ganti Ban', 'Overhaul Mesin', 'Kaki-kaki'
  final String vehicleType; // 'MPV', 'SUV', 'Sedan', 'Hatchback', 'City Car'
  final int year;
  final int kilometer;
  final bool replaceEngineOil;
  final bool replaceFilter;
  final bool replaceBrakePad;
  final bool replaceSparkPlugs;

  ServiceEstimationInput({
    required this.category,
    required this.vehicleType,
    required this.year,
    required this.kilometer,
    this.replaceEngineOil = true,
    this.replaceFilter = false,
    this.replaceBrakePad = false,
    this.replaceSparkPlugs = false,
  });
}

class ServiceEstimationResult {
  final double estimatedCost;
  final double minCost;
  final double maxCost;
  final double laborCost;
  final double sparepartCost;
  final int estimatedDurationMinutes;
  final double confidenceScore;
  final Map<String, double> featureImportance;

  ServiceEstimationResult({
    required this.estimatedCost,
    required this.minCost,
    required this.maxCost,
    required this.laborCost,
    required this.sparepartCost,
    required this.estimatedDurationMinutes,
    required this.confidenceScore,
    required this.featureImportance,
  });
}
