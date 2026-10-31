import 'package:flutter_test/flutter_test.dart';
import 'package:auto_garage_201/models/garage_service.dart';

void main() {
  group('GarageServiceCatalog', () {
    test('includes all preview services and existing booking options', () {
      expect(
        GarageServiceCatalog.services.map((service) => service.name),
        containsAll([
          'Servis Berkala',
          'Ganti Oli Mesin & Transmisi',
          'Overhaul Mesin (Turun Mesin)',
          'Perawatan Sistem Rem & Understeel',
          'Tuning ECU & Remap Stage 1 / 2',
          'Purging Diesel & Kalibrasi Injektor',
          'Pemasangan Downpipe Stainless 304',
          'AC Service',
          'Tune Up',
          'Ganti Ban',
        ]),
      );
    });

    test('catalog prices use the preview prices and preserve price notes', () {
      final oilService =
          GarageServiceCatalog.findByName('Ganti Oli Mesin & Transmisi');
      final ecuService =
          GarageServiceCatalog.findByName('Tuning ECU & Remap Stage 1 / 2');

      expect(oilService?.basePrice, 150000);
      expect(oilService?.priceLabel, 'Rp 150.000 (jasa)');
      expect(oilService?.priceNote, isNotEmpty);
      expect(ecuService?.basePrice, 800000);
      expect(ecuService?.priceLabel, 'Rp 800.000–2.500.000');
      expect(ecuService?.priceNote, isNotEmpty);
      expect(ecuService?.options, ['Stage 1', 'Stage 2']);
    });

    test('unknown service names do not silently resolve to another service',
        () {
      expect(GarageServiceCatalog.findByName('Layanan Tidak Dikenal'), isNull);
    });
  });
}
