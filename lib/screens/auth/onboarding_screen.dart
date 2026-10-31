import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_visuals.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: const Color(0xFF0B0E13),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 480,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/201_auto_garage_brand.png',
                                width: 142,
                                height: 142,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                excludeFromSemantics: true,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Drive Better, We Care',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: authInk,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mudah booking, harga transparan, layanan terpercaya.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  height: 1.6,
                                  color: authMuted,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 210,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFFFF3B45)
                                            .withValues(alpha: 0.18),
                                        const Color(0xFF0B0E13)
                                            .withValues(alpha: 0),
                                      ],
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.directions_car_filled_rounded,
                                  size: 118,
                                  color: Color(0xFFFF3B45),
                                  shadows: [
                                    Shadow(
                                      color: Color(0x66FF3B45),
                                      blurRadius: 32,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: GradientAction(
                                  onPressed: () => context.go('/sign-in'),
                                  child: Text(
                                    'Masuk',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () => context.go('/sign-up'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: authInk,
                                    side: const BorderSide(
                                      color: Color(0xFF626873),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Daftar Akun',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
