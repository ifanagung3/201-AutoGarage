import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AllowNotificationScreen extends StatelessWidget {
  const AllowNotificationScreen({super.key});

  static const Color bgColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimaryColor = Color(0xFF1E293B);
  static const Color textSecondaryColor = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Step Indicator / Back Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/allow-location');
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor, size: 20),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  Text(
                    'Langkah 3 dari 3',
                    style: GoogleFonts.poppins(
                      color: textSecondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              // Center Graphic & Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bell Illustration
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Concentric pulse backgrounds
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withValues(alpha: 0.06),
                        ),
                      ),
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withValues(alpha: 0.12),
                        ),
                      ),
                      // Core Circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.4),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.notifications_active_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 48),

                  // Title
                  Text(
                    'Aktifkan Akses Notifikasi',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 16),

                  // Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Aktifkan notifikasi untuk menerima pembaruan secara real-time status servis kendaraan Anda.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        color: textSecondaryColor,
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                ],
              ),

              // Bottom Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Allow Notification Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: primaryColor.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Allow Notification',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 12),

                  // Maybe Later Button
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Maybe Later',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textSecondaryColor,
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
