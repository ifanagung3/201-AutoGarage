import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingLayananScreen extends StatelessWidget {
  const BookingLayananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pilih Layanan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ServiceCard(
              title: 'Servis Rutin',
              description: 'Ganti oli, filter, dan pemeriksaan umum',
              price: 'Rp 150.000',
              onTap: () => context.go('/booking/tanggal'),
            ),
            const SizedBox(height: 12),
            _ServiceCard(
              title: 'Tune Up',
              description: 'Pembersihan mesin dan penyetelan performa',
              price: 'Rp 300.000',
              onTap: () => context.go('/booking/tanggal'),
            ),
            const SizedBox(height: 12),
            _ServiceCard(
              title: 'AC Service',
              description: 'Pembersihan dan pengisian freon AC',
              price: 'Rp 200.000',
              onTap: () => context.go('/booking/tanggal'),
            ),
            const SizedBox(height: 12),
            _ServiceCard(
              title: 'Ganti Ban',
              description: 'Penggantian dan balancing ban mobil',
              price: 'Rp 400.000',
              onTap: () => context.go('/booking/tanggal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.build_circle,
                  color: Color(0xFF3B82F6),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
