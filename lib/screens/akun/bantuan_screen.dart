import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'Bagaimana cara melakukan booking servis?', 'a': 'Pilih menu Booking di beranda, tentukan layanan, tanggal, waktu, dan konfirmasi pesanan Anda.'},
      {'q': 'Apakah mekanik bisa datang ke rumah?', 'a': 'Saat ini layanan kami melayani kunjungan langsung di bengkel 201 Auto Garage.'},
      {'q': 'Bagaimana cara menggunakan voucher promo?', 'a': 'Masukkan kode promo pada halaman ringkasan konfirmasi booking.'},
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
          'Pusat Bantuan',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FAQ (Pertanyaan Populer)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 12),
            ...faqs.map((f) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: ExpansionTile(
                    title: Text(f['q']!, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(f['a']!, style: GoogleFonts.poppins(fontSize: 13, color: textSecondary, height: 1.4)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.headset_mic_rounded, size: 40, color: primaryColor),
                  const SizedBox(height: 12),
                  Text('Butuh Bantuan Lebih Lanjut?', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                  const SizedBox(height: 4),
                  Text('Tim support kami siap membantu Anda 24/7.', style: GoogleFonts.poppins(fontSize: 13, color: textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menghubungkan ke CS WhatsApp...'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    icon: const Icon(Icons.chat_rounded, color: Colors.white),
                    label: Text('Hubungi CS WhatsApp', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
