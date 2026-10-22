import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Text('Kelola Booking', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: const Color(0xFFF97316),
          labelColor: const Color(0xFFF97316),
          unselectedLabelColor: Colors.grey[400],
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Menunggu'),
            Tab(text: 'Proses'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari nama, plat nomor, atau layanan...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<BookingModel>>(
              stream: BookingService.instance.streamAllBookings(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Gagal memuat booking: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.white70)),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFF97316)));
                }

                final allBookings = snapshot.data!;
                final filtered = allBookings.where((b) {
                  final q = _searchQuery.toLowerCase();
                  return b.userName.toLowerCase().contains(q) ||
                      b.vehiclePlat.toLowerCase().contains(q) ||
                      b.serviceName.toLowerCase().contains(q) ||
                      b.id.toLowerCase().contains(q);
                }).toList();

                return TabBarView(
                  controller: _tabs,
                  children: [
                    _BookingList(bookings: filtered),
                    _BookingList(bookings: filtered.where((b) => b.status == 'Menunggu').toList()),
                    _BookingList(bookings: filtered.where((b) => b.status == 'Proses Pengecekan' || b.status == 'Sedang Dikerjakan' || b.status == 'Quality Check').toList()),
                    _BookingList(bookings: filtered.where((b) => b.status == 'Selesai' || b.status == 'Dibatalkan').toList()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabs.dispose();
    super.dispose();
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('Belum ada data booking', style: GoogleFonts.poppins(color: Colors.grey[400])),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _BookingCard(booking: bookings[index]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return const Color(0xFFF59E0B);
      case 'Proses Pengecekan':
      case 'Sedang Dikerjakan':
      case 'Quality Check':
        return const Color(0xFF3B82F6);
      case 'Selesai':
        return const Color(0xFF10B981);
      case 'Dibatalkan':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void _confirmAction(BuildContext context, {required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(message, style: GoogleFonts.poppins(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            child: const Text('Ya, Lanjutkan'),
          ),
        ],
      ),
    );
  }

  void _showAuditLogDialog(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Riwayat Perubahan (${booking.id})', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        content: SizedBox(
          width: double.maxFinite,
          child: booking.statusHistory.isEmpty
              ? Text('Belum ada log riwayat', style: GoogleFonts.poppins(color: Colors.grey))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: booking.statusHistory.length,
                  itemBuilder: (context, index) {
                    final log = booking.statusHistory[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded, color: Color(0xFFF97316), size: 20),
                      title: Text(log.status, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('Oleh: ${log.updatedBy} • ${dateFormat.format(log.timestamp)}', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFFF97316))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final color = _getStatusColor(booking.status);

    final displayId = booking.id.length > 10 ? '#${booking.id.substring(0, 8)}...' : booking.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayId,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status,
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Pelanggan: ${booking.userName} (${booking.userPhone})', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[300])),
          Text('Kendaraan: ${booking.vehicleName} [${booking.vehiclePlat}]', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Layanan: ${booking.serviceName}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Jadwal: ${dateFormat.format(booking.bookingDate)}, ${booking.bookingTime}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Biaya: ${currencyFormat.format(booking.estimatedCost)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFF97316))),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.history_rounded, color: Colors.grey),
                tooltip: 'Lihat Audit Log',
                onPressed: () => _showAuditLogDialog(context),
              ),
              const Spacer(),
              if (booking.status == 'Menunggu') ...[
                ElevatedButton(
                  onPressed: () => _confirmAction(
                    context,
                    title: 'Terima Booking?',
                    message: 'Booking ${booking.id} akan diproses ke tahap Pengecekan.',
                    onConfirm: () => BookingService.instance.updateBookingStatus(booking.id, 'Proses Pengecekan', 2, updatedBy: 'Admin'),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  child: const Text('Terima'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _confirmAction(
                    context,
                    title: 'Tolak Booking?',
                    message: 'Booking ${booking.id} akan dibatalkan.',
                    onConfirm: () => BookingService.instance.updateBookingStatus(booking.id, 'Dibatalkan', 1, updatedBy: 'Admin'),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  child: const Text('Tolak'),
                ),
              ],
              if (booking.status != 'Selesai' && booking.status != 'Dibatalkan') ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  tooltip: 'Hapus Booking',
                  onPressed: () => _confirmAction(
                    context,
                    title: 'Hapus Booking?',
                    message: 'Apakah Anda yakin ingin menghapus permanen ${booking.id}?',
                    onConfirm: () => BookingService.instance.deleteBooking(booking.id),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
