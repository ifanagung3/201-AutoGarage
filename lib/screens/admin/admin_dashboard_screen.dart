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
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: StreamBuilder<List<BookingModel>>(
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

            return CustomScrollView(
              slivers: [
                // Header Bar
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF97316).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFF97316), size: 28),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '201 Auto Garage',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Dashboard Control Center',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                          ),
                          tooltip: 'Keluar Admin',
                          onPressed: () async {
                            await AuthService.instance.signOut();
                            if (context.mounted) context.go('/sign-in');
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content Body
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListChildDelegate([
                      // Revenue Header Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFEA580C), Color(0xFFC2410C), Color(0xFF9A3412)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pendapatan Servis Selesai',
                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.trending_up, color: Colors.white, size: 14),
                                      const SizedBox(width: 4),
                                      Text('Terverifikasi', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currencyFormat.format(totalRevenue),
                              style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Akumulasi dari $completedCount transaksi servis yang berstatus Selesai',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Title
                      Text(
                        'Ringkasan Booking Real-Time',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 14),

                      // 2x2 Grid of Stat Cards
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.35,
                        children: [
                          _StatCard(title: 'Total Booking', value: totalCount.toString(), icon: Icons.book_online_rounded, color: const Color(0xFF3B82F6)),
                          _StatCard(title: 'Menunggu', value: pendingCount.toString(), icon: Icons.pending_actions_rounded, color: const Color(0xFFF59E0B)),
                          _StatCard(title: 'Sedang Proses', value: activeCount.toString(), icon: Icons.build_circle_rounded, color: const Color(0xFF06B6D4)),
                          _StatCard(title: 'Selesai', value: completedCount.toString(), icon: Icons.check_circle_rounded, color: const Color(0xFF10B981)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Menu Pintas Grid
                      Text(
                        'Akses Pintas Pengelolaan',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _ShortcutTile(
                              title: 'Input Estimasi',
                              subtitle: 'Hitung Biaya',
                              icon: Icons.calculate_rounded,
                              color: const Color(0xFFF97316),
                              onTap: () => context.go('/admin/estimasi'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ShortcutTile(
                              title: 'Data Pelanggan',
                              subtitle: 'Sync Profile',
                              icon: Icons.people_alt_rounded,
                              color: const Color(0xFF3B82F6),
                              onTap: () => context.go('/admin/pelanggan'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ShortcutTile(
                              title: 'Kelola Promo',
                              subtitle: 'Diskon Bengkel',
                              icon: Icons.local_offer_rounded,
                              color: const Color(0xFFEC4899),
                              onTap: () => context.go('/admin/promo'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ShortcutTile(
                              title: 'Tahap Servis',
                              subtitle: 'Update Progress',
                              icon: Icons.speed_rounded,
                              color: const Color(0xFF10B981),
                              onTap: () => context.go('/admin/servis'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
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
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ShortcutTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
