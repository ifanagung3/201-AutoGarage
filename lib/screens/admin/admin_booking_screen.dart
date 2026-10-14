// lib/screens/admin/admin_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> with SingleTickerProviderStateMixin {
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);

  late TabController _tabController;

  final List<Map<String, dynamic>> _bookings = [
    {'id': '1', 'name': 'Budi Santoso', 'car': 'Toyota Avanza', 'service': 'Servis Berkala', 'date': '13 Okt 2026', 'time': '09:00', 'status': 'menunggu'},
    {'id': '2', 'name': 'Rina Marlina', 'car': 'Honda Jazz', 'service': 'Ganti Oli', 'date': '13 Okt 2026', 'time': '10:30', 'status': 'proses'},
    {'id': '3', 'name': 'Dani Kusuma', 'car': 'Mitsubishi Xpander', 'service': 'Servis AC', 'date': '13 Okt 2026', 'time': '11:00', 'status': 'selesai'},
    {'id': '4', 'name': 'Sari Dewi', 'car': 'Daihatsu Sigra', 'service': 'Tune Up', 'date': '13 Okt 2026', 'time': '13:00', 'status': 'menunggu'},
    {'id': '5', 'name': 'Ahmad Fauzi', 'car': 'Suzuki Ertiga', 'service': 'Ganti Ban', 'date': '13 Okt 2026', 'time': '14:30', 'status': 'proses'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filtered(String filter) {
    if (filter == 'semua') return _bookings;
    return _bookings.where((b) => b['status'] == filter).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'menunggu': return primaryColor;
      case 'proses': return const Color(0xFF3B82F6);
      case 'selesai': return const Color(0xFF22C55E);
      default: return textSecondary;
    }
  }

  void _terima(String id) {
    setState(() {
      final idx = _bookings.indexWhere((b) => b['id'] == id);
      if (idx != -1) _bookings[idx]['status'] = 'proses';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking diterima! Status diubah ke Proses.'), behavior: SnackBarBehavior.floating),
    );
  }

  void _tolak(String id) {
    setState(() => _bookings.removeWhere((b) => b['id'] == id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking ditolak dan dihapus.'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b) {
    final status = b['status'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.directions_car_rounded, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('${b['car']} • ${b['service']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: GoogleFonts.poppins(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: textSecondary, size: 14),
              const SizedBox(width: 4),
              Text('${b['date']} • ${b['time']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
            ],
          ),
          if (status == 'menunggu') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _terima(b['id'] as String),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('Terima', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _tolak(b['id'] as String),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text('Tolak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text('Kelola Booking', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: textSecondary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [Tab(text: 'Semua'), Tab(text: 'Menunggu'), Tab(text: 'Proses'), Tab(text: 'Selesai')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: ['semua', 'menunggu', 'proses', 'selesai'].map((filter) {
          final list = _filtered(filter);
          if (list.isEmpty) {
            return Center(child: Text('Tidak ada booking.', style: GoogleFonts.poppins(color: textSecondary)));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: list.map(_buildBookingCard).toList(),
          );
        }).toList(),
      ),
    );
  }
}
