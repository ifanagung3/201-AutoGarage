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

class _AdminBookingScreenState extends State<AdminBookingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          'Kelola Booking',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabs,
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
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingService.instance.streamAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _Message('Gagal memuat booking: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bookings = snapshot.data!;
          return TabBarView(
            controller: _tabs,
            children: [
              _BookingList(bookings: bookings),
              _BookingList(
                bookings: bookings
                    .where((b) => b.status == 'Menunggu')
                    .toList(),
              ),
              _BookingList(
                bookings: bookings
                    .where(
                      (b) => b.status != 'Menunggu' && b.status != 'Selesai',
                    )
                    .toList(),
              ),
              _BookingList(
                bookings: bookings.where((b) => b.status == 'Selesai').toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({required this.bookings});
  final List<BookingModel> bookings;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const _Message('Belum ada booking.');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _BookingCard(booking: bookings[index]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});
  final BookingModel booking;

  Future<void> _update(BuildContext context, String status, int step) async {
    try {
      await BookingService.instance.updateBookingStatus(
        booking.id,
        status,
        step,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status booking diperbarui')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = booking.status == 'Selesai'
        ? Colors.green
        : booking.status == 'Menunggu'
        ? Colors.orange
        : Colors.blue;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              Expanded(
                child: Text(
                  'Booking #${booking.id}',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                booking.status,
                style: GoogleFonts.poppins(fontSize: 12, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Pelanggan: ${booking.userName}', style: _muted),
          Text('Layanan: ${booking.serviceName}', style: _muted),
          Text(
            'Tanggal: ${DateFormat('d MMM yyyy', 'id_ID').format(booking.bookingDate)}, ${booking.bookingTime}',
            style: _muted,
          ),
          if (booking.status == 'Menunggu')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _update(context, 'Proses Pengecekan', 2),
                    child: const Text('Terima'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _update(context, 'Dibatalkan', 0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
              ],
            )
          else if (booking.status != 'Selesai' &&
              booking.status != 'Dibatalkan')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _update(context, 'Selesai', 5),
                child: const Text('Tandai Selesai'),
              ),
            ),
        ],
      ),
    );
  }

  static const _muted = TextStyle(color: Colors.white70);
}

class _Message extends StatelessWidget {
  const _Message(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    ),
  );
}
