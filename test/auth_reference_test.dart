import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/src/google_fonts_base.dart' as font_test;
import 'package:auto_garage_201/screens/auth/splash_screen.dart';
import 'package:auto_garage_201/screens/auth/onboarding_screen.dart';
import 'package:auto_garage_201/screens/auth/sign_in_screen.dart';

// Optional local fonts for design previews. No network requests in tests.
class _PreviewFonts extends AssetManifest {
  @override
  List<String> listAssets() => [
        for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold'])
          'preview/Poppins-$weight.ttf',
      ];
  @override
  List<AssetMetadata>? getAssetVariants(String key) => null;
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final fontDir = Platform.environment['AUTH_PREVIEW_FONTS'];
  final outputDir = Platform.environment['AUTH_PREVIEW_OUTPUT'];
  setUpAll(() async {
    final icons = FontLoader('MaterialIcons');
    icons.addFont(Future.value(ByteData.sublistView(
      File('build/unit_test_assets/fonts/MaterialIcons-Regular.otf')
          .readAsBytesSync(),
    )));
    await icons.load();
    GoogleFonts.config.allowRuntimeFetching = false;
    font_test.assetManifest = _PreviewFonts();
    binding.defaultBinaryMessenger.setMockMessageHandler('flutter/assets',
        (message) async {
      final key = const StringCodec().decodeMessage(message)!;
      if (key.startsWith('preview/')) {
        if (fontDir != null) {
          final bytes =
              File('$fontDir/${key.split('/').last}').readAsBytesSync();
          return ByteData.sublistView(bytes);
        }
        // The test font is sufficient for behavior/overflow checks.
        final bytes = File(
                '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf')
            .readAsBytesSync();
        return ByteData.sublistView(bytes);
      }
      final asset = File('build/unit_test_assets/$key');
      if (asset.existsSync()) {
        return ByteData.sublistView(asset.readAsBytesSync());
      }
      return null;
    });
  });

  for (final size in [const Size(430, 932), const Size(360, 640)]) {
    testWidgets('Auth flow and layout at ${size.width}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final router = GoRouter(initialLocation: '/splash', routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(
            path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
        GoRoute(
            path: '/sign-up',
            builder: (_, __) => const Scaffold(body: Text('Register target'))),
        GoRoute(
            path: '/forgot-password',
            builder: (_, __) => const Scaffold(body: Text('Reset target'))),
      ]);
      addTearDown(router.dispose);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(RepaintBoundary(
        key: boundaryKey,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(padding: const EdgeInsets.only(top: 44, bottom: 24)),
            child: child!,
          ),
        ),
      ));
      Future<void> capture(String name) async {
        await tester.runAsync(() async {
          await GoogleFonts.pendingFonts();
          for (final element in find.byType(Image).evaluate()) {
            await precacheImage((element.widget as Image).image, element);
          }
        });
        await tester.pump();
        if (outputDir != null && size.width == 430) {
          await tester.runAsync(() async {
            final boundary = boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
            final image = await boundary.toImage();
            final bytes =
                await image.toByteData(format: ui.ImageByteFormat.png);
            await Directory(outputDir).create(recursive: true);
            await File('$outputDir/$name.png')
                .writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
        expect(tester.takeException(), isNull);
      }

      await capture('splash');
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Rawat Mobil Anda'), findsOneWidget);
      await capture('onboarding');
      await tester.tap(find.text('Let’s Started'));
      await tester.pumpAndSettle();
      await capture('sign-in');
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).last, 'contoh');
      await tester.tap(find.byTooltip('Tampilkan password'));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField).last).obscureText,
          isFalse);
      await tester.ensureVisible(find.text('Forgot Password?'));
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();
      expect(find.text('Reset target'), findsOneWidget);
    });
  }
}
