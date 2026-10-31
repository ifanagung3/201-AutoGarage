import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/service_estimation_model.dart';
import 'package:auto_garage_201/services/random_forest_service.dart';
import 'package:auto_garage_201/services/cache_service.dart';

void main() {
  group('Random Forest Service Unit Tests', () {
    setUp(() {
      // Clear cache before each test
      CacheService.instance.clear();
    });

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

    test(
        'predictViaApi fallback when server offline produces non-zero estimation',
        () async {
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

    test('predictViaApi uses cache for identical requests', () async {
      // First call
      final result1 = await RandomForestService.instance.predictViaApi(
        carBrand: 'Toyota',
        carModel: 'Avanza',
        carYear: 2020,
        serviceType: 'Servis Rutin',
        mileage: 50000,
        componentCount: 3,
      );

      // Second identical call should be faster (from cache)
      final result2 = await RandomForestService.instance.predictViaApi(
        carBrand: 'Toyota',
        carModel: 'Avanza',
        carYear: 2020,
        serviceType: 'Servis Rutin',
        mileage: 50000,
        componentCount: 3,
      );

      // Results should be identical
      expect(result1.estimatedCost, equals(result2.estimatedCost));
      expect(result1.estimatedDuration, equals(result2.estimatedDuration));
    });

    test('CacheService stores and retrieves values correctly', () {
      final cache = CacheService.instance;

      cache.set('test_key', 'test_value');

      expect(cache.has('test_key'), isTrue);
      expect(cache.get<String>('test_key'), equals('test_value'));
    });

    test('CacheService respects TTL expiration', () async {
      final cache = CacheService.instance;

      // Set with 1 second TTL
      cache.set('expire_key', 'expire_value', ttl: const Duration(seconds: 1));

      expect(cache.has('expire_key'), isTrue);

      // Wait for expiration
      await Future.delayed(const Duration(seconds: 2));

      expect(cache.has('expire_key'), isFalse);
      expect(cache.get<String>('expire_key'), isNull);
    });

    test('CacheService.generateKey creates consistent keys', () {
      final key1 = CacheService.generateKey('prefix', {'a': 1, 'b': 2});
      final key2 = CacheService.generateKey('prefix', {'b': 2, 'a': 1});

      // Keys should be identical regardless of parameter order
      expect(key1, equals(key2));
    });
  });
}
