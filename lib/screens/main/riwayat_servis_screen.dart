import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatServisScreen extends StatelessWidget {
  const RiwayatServisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Servis', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HistoryCard(layanan: 'Servis Rutin', tanggal: '15 September 2026', biaya: 'Rp 150.000'),
          const SizedBox(height: 12),
          _HistoryCard(layanan: 'Ganti Ban', tanggal: '10 Agustus 2026', biaya: 'Rp 400.000'),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String layanan, tanggal, biaya;
  const _HistoryCard({required this.layanan, required this.tanggal, required this.biaya});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.check, color: Colors.white)),
        title: Text(layanan, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(tanggal, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        trailing: Text(biaya, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
      ),
    );
  }
}
