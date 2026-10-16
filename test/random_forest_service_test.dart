import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/service_estimation_model.dart';
import 'package:auto_garage_201/services/random_forest_service.dart';

void main() {
  group('Random Forest Service Unit Tests', () {
    test('predictCost returns valid estimation result and positive values', () {
      final input = ServiceEstimationInput(
        category: 'Tune Up',
        vehicleType: 'MPV',
        year: 2018,
        kilometer: 75000,
        replaceEngineOil: true,
        replaceFilter: true,
      );

      final result = RandomForestService.instance.predictCost(input);

      expect(result.estimatedCost, greaterThan(0));
      expect(result.minCost, lessThanOrEqualTo(result.estimatedCost));
      expect(result.maxCost, greaterThanOrEqualTo(result.estimatedCost));
      expect(result.confidenceScore, equals(0.94));
    });

    test('getModelMetrics returns valid skripsi evaluation metrics', () {
      final metrics = RandomForestService.instance.getModelMetrics();

      expect(metrics['algorithm'], equals('Random Forest Regression'));
      expect(metrics['mape'], lessThan(10.0)); // MAPE < 10%
      expect(metrics['rSquared'], greaterThan(0.85)); // R2 > 0.85
    });

    test('predictViaApi fallback when server offline produces non-zero estimation', () async {
      final apiResult = await RandomForestService.instance.predictViaApi(
        carBrand: 'Toyota',
        carModel: 'Avanza',
        carYear: 2018,
        serviceType: 'Tune Up',
        mileage: 75000,
        componentCount: 5,
      );

      expect(apiResult.estimatedCost, greaterThan(0));
      expect(apiResult.estimatedDuration, greaterThan(0.0));
      expect(apiResult.recommendation.isNotEmpty, isTrue);
    });
  });
}
