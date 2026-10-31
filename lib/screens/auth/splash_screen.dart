import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../services/admin_access_service.dart';
import 'auth_visuals.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 800), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    if (Firebase.apps.isEmpty) {
      context.go('/onboarding');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        context.go('/onboarding');
        return;
      }

      // User already signed in — check role and redirect accordingly.
      final isAdmin = await AdminAccessService.instance.isCurrentUserAdmin();
      if (!mounted) return;
      context.go(isAdmin ? '/admin' : '/home');
    } catch (_) {
      if (!mounted) return;
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: const Color(0xFF0B0E13),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 190,
                  height: 190,
                  child: ReferenceArtwork(logo: true),
                ),
              ],
            ),
          ),
        ),
      );
}
