import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Promo'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/akun'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PromoCard(title: 'Diskon 20% Servis Rutin', desc: 'Berlaku hingga 31 Oktober 2026', code: 'SERVIS20'),
          const SizedBox(height: 12),
          _PromoCard(title: 'Gratis Cuci Mobil', desc: 'Min. transaksi Rp 200.000', code: 'CUCIGRATIS'),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title, desc, code;
  const _PromoCard({required this.title, required this.desc, required this.code});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(code, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
            ),
          ],
        ),
      ),
    );
  }
}
