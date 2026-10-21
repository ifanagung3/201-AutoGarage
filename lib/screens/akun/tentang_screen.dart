import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/akun');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tentang Aplikasi'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBack(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car,
                  size: 100, color: Color(0xFF3B82F6)),
              const SizedBox(height: 24),
              Text('201 Auto Garage',
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Versi 1.0.0',
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 24),
              Text(
                  'Aplikasi booking servis kendaraan terpercaya dan mudah digunakan.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
