import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Tentang Aplikasi',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.directions_car_filled_rounded, size: 50, color: primaryColor),
              ),
              const SizedBox(height: 20),
              Text('201 Auto Garage', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: textPrimary)),
              const SizedBox(height: 4),
              Text('Versi 1.0.0+1', style: GoogleFonts.poppins(fontSize: 14, color: textSecondary)),
              const SizedBox(height: 24),
              Text(
                'Aplikasi resmi 201 Auto Garage untuk memudahkan Anda melakukan booking servis kendaraan mobil, memantau status pengerjaan bengkel, dan melihat riwayat servis dengan cepat dan transparan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13, color: textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),
              Text('© 2026 201 Auto Garage. All rights reserved.', style: GoogleFonts.poppins(fontSize: 12, color: textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
