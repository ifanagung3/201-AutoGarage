import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFFF6F7F9),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  try {
    await Firebase.initializeApp();
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error\n$stackTrace');
    runApp(FirebaseInitializationErrorApp(error: error));
    return;
  }

  runApp(const AutoGarageApp());
}

class FirebaseInitializationErrorApp extends StatelessWidget {
  const FirebaseInitializationErrorApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final details = error is FirebaseException
        ? (error as FirebaseException).code
        : 'Kesalahan konfigurasi';
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Aplikasi tidak dapat terhubung ke Firebase.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('Detail: $details', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: main,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AutoGarageApp extends StatelessWidget {
  const AutoGarageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '201 Auto Garage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        final path = appRouter.routeInformationProvider.value.uri.path;
        final isDarkAuthScreen = {
          '/splash',
          '/onboarding',
          '/sign-in',
          '/sign-up',
          '/otp',
          '/forgot-password',
          '/complete-profile',
          '/admin-login',
        }.contains(path);
        final systemUiStyle = isDarkAuthScreen
            ? SystemUiOverlayStyle.light.copyWith(
                systemNavigationBarColor: const Color(0xFF0B0E13),
              )
            : SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: const Color(0xFFF6F7F9),
              );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: appRouter,
    );
  }
}
