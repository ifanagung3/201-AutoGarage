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
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text('Kelola Booking', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFEA580C),
          labelColor: const Color(0xFFEA580C),
          unselectedLabelColor: Colors.grey,
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
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari pelanggan, plat nomor, atau layanan...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A3C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<BookingModel>>(
              stream: BookingService.instance.streamAllBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)));
                }

                final allBookings = snapshot.data ?? [];
                final filtered = allBookings.where((b) {
                  final q = _searchQuery.toLowerCase();
                  final matchQuery = b.userName.toLowerCase().contains(q) ||
                      b.vehiclePlat.toLowerCase().contains(q) ||
                      b.serviceName.toLowerCase().contains(q) ||
                      b.id.toLowerCase().contains(q);
                  return matchQuery;
                }).toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _BookingListView(bookings: filtered),
                    _BookingListView(bookings: filtered.where((b) => b.status == 'Menunggu').toList()),
                    _BookingListView(bookings: filtered.where((b) => b.status == 'Proses Pengecekan' || b.status == 'Sedang Dikerjakan' || b.status == 'Quality Check').toList()),
                    _BookingListView(bookings: filtered.where((b) => b.status == 'Selesai' || b.status == 'Dibatalkan').toList()),
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
    _tabController.dispose();
    super.dispose();
  }
}

class _BookingListView extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingListView({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('Tidak ada data booking', style: GoogleFonts.poppins(color: Colors.grey)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _AdminBookingCard(booking: booking);
      },
    );
  }
}

class _AdminBookingCard extends StatelessWidget {
  final BookingModel booking;
  const _AdminBookingCard({required this.booking});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Proses Pengecekan':
      case 'Sedang Dikerjakan':
      case 'Quality Check':
        return const Color(0xFF3B82F6);
      case 'Selesai':
        return const Color(0xFF10B981);
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmAction(BuildContext context, {required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3C),
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C)),
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
        backgroundColor: const Color(0xFF2A2A3C),
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
                      leading: const Icon(Icons.history, color: Color(0xFFEA580C), size: 20),
                      title: Text(log.status, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('Oleh: ${log.updatedBy} • ${dateFormat.format(log.timestamp)}', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFFEA580C))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    final color = _getStatusColor(booking.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.id, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(booking.status, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Pelanggan: ${booking.userName} (${booking.userPhone})', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[300])),
          Text('Kendaraan: ${booking.vehicleName} [${booking.vehiclePlat}]', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Layanan: ${booking.serviceName}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Jadwal: ${dateFormat.format(booking.bookingDate)}, ${booking.bookingTime}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          Text('Biaya: ${currencyFormat.format(booking.estimatedCost)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C))),
          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.grey),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Tolak'),
                ),
              ],
              if (booking.status != 'Selesai' && booking.status != 'Dibatalkan') ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
