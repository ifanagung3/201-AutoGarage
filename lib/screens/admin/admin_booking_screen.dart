import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: Text('Kelola Booking', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFEA580C),
          labelColor: const Color(0xFFEA580C),
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: 'Semua'), Tab(text: 'Menunggu'), Tab(text: 'Proses'), Tab(text: 'Selesai')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BookingList(status: 'semua'),
          _BookingList(status: 'menunggu'),
          _BookingList(status: 'proses'),
          _BookingList(status: 'selesai'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _BookingList extends StatelessWidget {
  final String status;
  const _BookingList({required this.status});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => _BookingCard(index: index, status: status),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final int index;
  final String status;
  const _BookingCard({required this.index, required this.status});

  @override
  Widget build(BuildContext context) {
    final statuses = ['Menunggu', 'Proses', 'Selesai'];
    final colors = [Colors.orange, Colors.blue, Colors.green];
    final s = statuses[index % 3];
    final c = colors[index % 3];

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
              Text('Booking #00${index + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: c.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(s, style: GoogleFonts.poppins(fontSize: 12, color: c)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Pelanggan: Budi Santoso', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
          Text('Layanan: Servis Rutin', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
          Text('Tanggal: 20 Oktober 2026, 09:00', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
          const SizedBox(height: 12),
          if (s == 'Menunggu') Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Terima'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Tolak'))),
            ],
          ),
        ],
      ),
    );
  }
}
