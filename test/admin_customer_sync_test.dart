import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
// Test-only font fixture; no external font requests.
// ignore: implementation_imports
import 'package:google_fonts/src/google_fonts_base.dart' as font_test;
import 'package:auto_garage_201/screens/admin/admin_pelanggan_screen.dart';

class TestFonts extends AssetManifest {
  @override
  List<String> listAssets() => [
        for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold'])
          'test-fonts/Poppins-$weight.ttf',
      ];
  @override
  List<AssetMetadata>? getAssetVariants(String key) => null;
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    font_test.assetManifest = TestFonts();
    binding.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
        (message) async {
      final key = const StringCodec().decodeMessage(message)!;
      if (key.startsWith('test-fonts/')) {
        return ByteData.sublistView(File(
          '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytesSync());
      }
      final file = File('build/unit_test_assets/$key');
      return file.existsSync()
          ? ByteData.sublistView(file.readAsBytesSync())
          : null;
    });
  });

  testWidgets('live updates and search reuse the same subscription',
      (tester) async {
    int subscriptions = 0;
    final controller = StreamController<List<Map<String, dynamic>>>(
      onListen: () => subscriptions++,
    );
    addTearDown(controller.close);
    await tester.pumpWidget(MaterialApp(
        home: AdminPelangganScreen(customersStream: controller.stream)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    controller.add([]);
    await tester.pumpAndSettle();
    expect(
        find.text('Belum ada pelanggan terdaftar di database'), findsOneWidget);
    controller.add([
      {'name': 'Siti', 'email': 'siti@example.com', 'phone': '081234'}
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Siti'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '  SITI  ');
    await tester.pumpAndSettle();
    expect(find.text('Siti'), findsOneWidget);
    expect(subscriptions, 1);
    controller.add([
      {'name': 'Siti Baru', 'email': 'siti@example.com'}
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Siti Baru'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'tidak cocok');
    await tester.pumpAndSettle();
    expect(find.text('Pelanggan tidak ditemukan'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  for (final code in ['permission-denied', 'unavailable']) {
    testWidgets('$code is displayed instead of empty or sample data',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: AdminPelangganScreen(
        customersStream: Stream.error(
            FirebaseException(plugin: 'cloud_firestore', code: code)),
      )));
      await tester.pumpAndSettle();
      expect(
          find.textContaining(code == 'permission-denied'
              ? 'Akses pelanggan ditolak'
              : 'Gagal menyinkronkan'),
          findsOneWidget);
      expect(find.text('Coba lagi'), findsOneWidget);
      expect(
          find.text('Belum ada pelanggan terdaftar di database'), findsNothing);
    });
  }

  testWidgets(
      'empty customer name and detail dialog do not crash on small screen',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        home: AdminPelangganScreen(
      customersStream: Stream.value([
        {'name': '', 'email': 'customer@example.com'}
      ]),
    )));
    await tester.pumpAndSettle();
    expect(find.text('P'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.info_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Tanggal Daftar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
