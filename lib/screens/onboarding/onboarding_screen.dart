import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const Color primaryBlue = Color(0xFF4361EE);
  static const Color textSecondary = Color(0xFF64748B);
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF5B67CA), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28.0, 36.0, 28.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rawat Mobil Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 14),
                  Text(
                    'Cara tercepat untuk memesan layanan bengkel mobil tanpa repot menunggu atau menanti kepastian harga.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textSecondary,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                  const SizedBox(height: 28),
                  // "Let's Started ->" button
                  InkWell(
                    onTap: () => context.go('/sign-in'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Let's Started",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                ],
              ),
            ),
            const Spacer(),
            // Sports Car Graphic placed at bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/sports_car.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}
