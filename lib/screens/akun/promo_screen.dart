import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final promos = [
      {'title': 'Diskon Servis Berkala 20%', 'code': 'GARAGE20', 'desc': 'Berlaku untuk semua jenis servis mesin dan ganti oli.'},
      {'title': 'Gratis Pengecekan Kaki-Kaki', 'code': 'FREECHECK', 'desc': 'Checkup 32 titik gratis tanpa syarat minimum transaksi.'},
      {'title': 'Cashback 50rb Servis AC', 'code': 'ACCOOL50', 'desc': 'Khusus pemesanan layanan cuci & servis AC mobil.'},
    ];

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
          'Promo & Voucher',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final p = promos[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(p['title']!, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(p['code']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(p['desc']!, style: GoogleFonts.poppins(fontSize: 13, color: textSecondary)),
              ],
            ),
          );
        },
      ),
    );
  }
}
