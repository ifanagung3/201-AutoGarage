import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_visuals.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final width = math.min(constraints.maxWidth, 500.0);
            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: width,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    authGradient.createShader(bounds),
                                child: Text('Rawat Mobil Anda',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    )),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Cara tercepat untuk memesan layanan bengkel mobil tanpa repot menunggu atau menanti kepastian harga.',
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: authMuted),
                              ),
                              const SizedBox(height: 32),
                              GradientAction(
                                onPressed: () => context.go('/sign-in'),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Let’s Started',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16)),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.arrow_forward, size: 22),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: math.max(
                                48,
                                constraints.maxHeight -
                                    270 -
                                    width * 494 / 430)),
                        const ReferenceArtwork(logo: false),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
}
