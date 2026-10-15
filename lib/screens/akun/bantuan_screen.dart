import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/akun'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            title: Text('Bagaimana cara booking servis?', style: GoogleFonts.poppins()),
            children: [Padding(padding: const EdgeInsets.all(16), child: Text('Pilih layanan → Pilih tanggal → Pilih waktu → Konfirmasi booking.', style: GoogleFonts.poppins(fontSize: 14)))],
          ),
          ExpansionTile(
            title: Text('Bagaimana cara membatalkan booking?', style: GoogleFonts.poppins()),
            children: [Padding(padding: const EdgeInsets.all(16), child: Text('Hubungi admin melalui WhatsApp atau telepon.', style: GoogleFonts.poppins(fontSize: 14)))],
          ),
        ],
      ),
    );
  }
}
