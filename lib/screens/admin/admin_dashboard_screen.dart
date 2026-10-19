import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../services/auth_service.dart';
import '../../services/booking_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text('Admin Dashboard', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService.instance.signOut();
              if (context.mounted) context.go('/sign-in');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingService.instance.streamAllBookings(),
        builder: (context, snapshot) {
          final bookings = snapshot.data ?? [];

          int totalCount = bookings.length;
          int pendingCount = bookings.where((b) => b.status == 'Menunggu').length;
          int activeCount = bookings.where((b) => b.status == 'Proses Pengecekan' || b.status == 'Sedang Dikerjakan' || b.status == 'Quality Check').length;
          int completedCount = bookings.where((b) => b.status == 'Selesai').length;

          double totalRevenue = bookings
              .where((b) => b.status == 'Selesai')
              .fold(0.0, (sum, item) => sum + item.estimatedCost);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ringkasan Real-Time Firestore', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _StatCard(title: 'Total Booking', value: totalCount.toString(), icon: Icons.book_online, color: const Color(0xFF3B82F6)),
                    _StatCard(title: 'Menunggu', value: pendingCount.toString(), icon: Icons.pending, color: const Color(0xFFEA580C)),
                    _StatCard(title: 'Sedang Proses', value: activeCount.toString(), icon: Icons.build, color: const Color(0xFF10B981)),
                    _StatCard(title: 'Selesai', value: completedCount.toString(), icon: Icons.check_circle, color: const Color(0xFF8B5CF6)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Pendapatan Transaksi Selesai', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFDC2626)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Pendapatan Terkonfirmasi', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(currencyFormat.format(totalRevenue), style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const Spacer(),
          Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
        ],
      ),
    );
  }
}
