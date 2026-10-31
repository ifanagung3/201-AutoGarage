import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: implementation_imports
import 'package:google_fonts/src/google_fonts_base.dart' as font_test;
import 'package:auto_garage_201/services/garage_diagnostics.dart';
import 'package:auto_garage_201/screens/booking/estimasi_biaya_screen.dart';

class DiagnosticFonts extends AssetManifest {
  @override
  List<String> listAssets() => [
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold'])
      'diagnostic-fonts/Poppins-$weight.ttf',
  ];
  @override
  List<AssetMetadata>? getAssetVariants(String key) => null;
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  test('measurement preserves result and logs timing only when enabled', () {
    final messages = <String>[];
    final previous = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    try {
      expect(GarageDiagnostics.measure('test.compute', () => 42), 42);
      if (GarageDiagnostics.enabled) {
        final event = jsonDecode(messages.last.split('[GARAGE_DIAG] ').last);
        expect(event['event'], 'test.compute.success');
        expect(event['elapsedUs'], isNonNegative);
      } else {
        expect(messages, isEmpty);
      }
    } finally {
      debugPrint = previous;
    }
  });

  test('measurement rethrows original failure without logging its contents', () {
    final messages = <String>[];
    final previous = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    try {
      final error = StateError('private-customer-value');
      expect(() => GarageDiagnostics.measure('test.compute', () => throw error),
        throwsA(same(error)));
      expect(messages.join(), isNot(contains('private-customer-value')));
      if (GarageDiagnostics.enabled) {
        expect(messages.last, contains('test.compute.error'));
      }
    } finally {
      debugPrint = previous;
    }
  });

  testWidgets('calculator produces result on first frame without API waiting', (tester) async {
    final initialAllowRuntimeFetching = GoogleFonts.config.allowRuntimeFetching;
    final initialAssetManifest = font_test.assetManifest;
    addTearDown(() {
      GoogleFonts.config.allowRuntimeFetching = initialAllowRuntimeFetching;
      font_test.assetManifest = initialAssetManifest;
    });
    GoogleFonts.config.allowRuntimeFetching = false;
    font_test.assetManifest = DiagnosticFonts();
    binding.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', (message) async {
      final key = const StringCodec().decodeMessage(message)!;
      if (key.startsWith('diagnostic-fonts/')) {
        return ByteData.sublistView(File(
          '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytesSync());
      }
      final file = File('build/unit_test_assets/$key');
      return file.existsSync() ? ByteData.sublistView(file.readAsBytesSync()) : null;
    });
    addTearDown(() => binding.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null));
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Load fixture fonts before the first layout; Ahem's wide test glyphs can
    // otherwise introduce overflows unrelated to the device's actual fonts.
    await tester.runAsync(() async {
      for (final weight in [FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700]) {
        GoogleFonts.poppins(fontWeight: weight);
      }
      await GoogleFonts.pendingFonts();
    });
    await tester.pumpWidget(const MaterialApp(home: EstimasiBiayaScreen()));
    expect(find.text('Hasil Prediksi Estimasi'), findsOneWidget);
    expect(find.text('Menghitung estimasi biaya...'), findsNothing);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
