import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (!mounted) return;
      final user = AuthService().currentUser;
      if (user == null) {
        context.go('/onboarding');
        return;
      }
      // Baca role dari Firestore
      final role = await AuthService().getUserRole(user.uid);
      if (!mounted) return;
      if (role == 'admin') {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 220,
          fit: BoxFit.contain,
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.85, 0.85), duration: 700.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}
