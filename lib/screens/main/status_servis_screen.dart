import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusServisScreen extends StatelessWidget {
  const StatusServisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Status Servis', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatusCard(layanan: 'Servis Rutin', tanggal: '20 Oktober 2026', status: 'Sedang Dikerjakan', progress: 0.6),
          const SizedBox(height: 12),
          _StatusCard(layanan: 'Tune Up', tanggal: '18 Oktober 2026', status: 'Menunggu Konfirmasi', progress: 0.2),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String layanan, tanggal, status;
  final double progress;
  const _StatusCard({required this.layanan, required this.tanggal, required this.status, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(layanan, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(tanggal, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 8),
            Text(status, style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF3B82F6), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
