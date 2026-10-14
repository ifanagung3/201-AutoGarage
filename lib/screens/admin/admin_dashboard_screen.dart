// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Booking Hari Ini', 'value': '8', 'icon': Icons.calendar_today_rounded, 'color': primaryColor},
      {'label': 'Menunggu', 'value': '3', 'icon': Icons.hourglass_empty_rounded, 'color': const Color(0xFFF59E0B)},
      {'label': 'Dikerjakan', 'value': '2', 'icon': Icons.build_rounded, 'color': const Color(0xFF3B82F6)},
      {'label': 'Selesai', 'value': '3', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF22C55E)},
    ];

    final recentBookings = [
      {'name': 'Budi Santoso', 'car': 'Toyota Avanza', 'service': 'Servis Berkala', 'status': 'menunggu'},
      {'name': 'Rina Marlina', 'car': 'Honda Jazz', 'service': 'Ganti Oli', 'status': 'proses'},
      {'name': 'Dani Kusuma', 'car': 'Mitsubishi Xpander', 'service': 'Servis AC', 'status': 'selesai'},
      {'name': 'Sari Dewi', 'car': 'Daihatsu Sigra', 'service': 'Tune Up', 'status': 'proses'},
    ];

    Color statusColor(String status) {
      switch (status) {
        case 'menunggu': return primaryColor;
        case 'proses': return const Color(0xFF3B82F6);
        case 'selesai': return const Color(0xFF22C55E);
        default: return textSecondary;
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text('Dashboard Admin', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) context.go('/sign-in');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat datang, Admin 👋', style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Senin, 13 Oktober 2026', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
            const SizedBox(height: 24),

            // Statistik cards 2x2
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: stats.map((s) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (s['color'] as Color).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(s['icon'] as IconData, color: s['color'] as Color, size: 28),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['value'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 26, fontWeight: FontWeight.bold)),
                        Text(s['label'] as String, style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              )).toList(),
            ),
            const SizedBox(height: 20),

            // Kartu Pendapatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pendapatan Hari Ini', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      Text('Rp 2.450.000', style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Booking Terbaru', style: GoogleFonts.poppins(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...recentBookings.map((b) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14)),
              child: Row(
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
                        Text(b['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('${b['car']} • ${b['service']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor(b['status'] as String).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      b['status'] as String,
                      style: GoogleFonts.poppins(color: statusColor(b['status'] as String), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
