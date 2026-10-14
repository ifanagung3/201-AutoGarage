// lib/screens/admin/admin_pelanggan_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPelangganScreen extends StatefulWidget {
  const AdminPelangganScreen({super.key});

  @override
  State<AdminPelangganScreen> createState() => _AdminPelangganScreenState();
}

class _AdminPelangganScreenState extends State<AdminPelangganScreen> {
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color inputFill = Color(0xFF353548);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _pelanggan = [
    {'name': 'Budi Santoso', 'email': 'budi.s@gmail.com', 'phone': '0812-1111-2222', 'bookings': 5, 'car': 'Toyota Avanza'},
    {'name': 'Rina Marlina', 'email': 'rina.m@gmail.com', 'phone': '0813-2222-3333', 'bookings': 3, 'car': 'Honda Jazz'},
    {'name': 'Dani Kusuma', 'email': 'dani.k@yahoo.com', 'phone': '0821-3333-4444', 'bookings': 7, 'car': 'Mitsubishi Xpander'},
    {'name': 'Sari Dewi', 'email': 'sari.d@gmail.com', 'phone': '0851-4444-5555', 'bookings': 2, 'car': 'Daihatsu Sigra'},
    {'name': 'Ahmad Fauzi', 'email': 'ahmad.f@outlook.com', 'phone': '0878-5555-6666', 'bookings': 4, 'car': 'Suzuki Ertiga'},
    {'name': 'Dewi Lestari', 'email': 'dewi.l@gmail.com', 'phone': '0896-6666-7777', 'bookings': 1, 'car': 'Nissan March'},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _pelanggan;
    return _pelanggan.where((p) =>
      (p['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (p['email'] as String).toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _showDetail(Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64, height: 64,
                decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withValues(alpha: 0.2)),
                child: Center(
                  child: Text(
                    (p['name'] as String)[0].toUpperCase(),
                    style: GoogleFonts.poppins(color: primaryColor, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text(p['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            _detailRow(Icons.email_outlined, 'Email', p['email'] as String),
            _detailRow(Icons.phone_outlined, 'Nomor HP', p['phone'] as String),
            _detailRow(Icons.directions_car_outlined, 'Kendaraan', p['car'] as String),
            _detailRow(Icons.receipt_long_rounded, 'Total Booking', '${p['bookings']} kali servis'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
              Text(value, style: GoogleFonts.poppins(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text('Data Pelanggan', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(color: textPrimary),
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputFill,
                hintText: 'Cari nama atau email...',
                hintStyle: GoogleFonts.poppins(color: textSecondary),
                prefixIcon: const Icon(Icons.search_rounded, color: textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final p = _filtered[index];
                return GestureDetector(
                  onTap: () => _showDetail(p),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withValues(alpha: 0.2)),
                          child: Center(
                            child: Text(
                              (p['name'] as String)[0].toUpperCase(),
                              style: GoogleFonts.poppins(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                              Text(p['email'] as String, style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                              Text(p['car'] as String, style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                          child: Text('${p['bookings']}x', style: GoogleFonts.poppins(color: const Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
