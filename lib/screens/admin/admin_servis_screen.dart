import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class AdminServisScreen extends StatelessWidget {
  const AdminServisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text('Update Tahap Servis', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingService.instance.streamAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)));
          }

          final allBookings = snapshot.data ?? [];
          final activeServisList = allBookings
              .where((b) => b.status != 'Selesai' && b.status != 'Dibatalkan')
              .toList();

          if (activeServisList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build_outlined, size: 60, color: Colors.grey[600]),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada servis aktif saat ini',
                    style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: activeServisList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final booking = activeServisList[index];
              return _ServisCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _ServisCard extends StatelessWidget {
  final BookingModel booking;
  const _ServisCard({required this.booking});

  static const List<String> steps = [
    'Penerimaan Kendaraan',
    'Proses Pengecekan',
    'Sedang Dikerjakan',
    'Quality Check',
    'Selesai'
  ];

  Future<void> _advanceStep(BuildContext context) async {
    int nextStep = booking.currentStep + 1;
    String nextStatus = booking.status;

    if (nextStep == 2) nextStatus = 'Proses Pengecekan';
    if (nextStep == 3) nextStatus = 'Sedang Dikerjakan';
    if (nextStep == 4) nextStatus = 'Quality Check';
    if (nextStep >= 5) {
      nextStep = 5;
      nextStatus = 'Selesai';
    }

    await BookingService.instance.updateBookingStatus(booking.id, nextStatus, nextStep);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tahap servis ${booking.id} berhasil diupdate ke $nextStatus!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentStepIndex = (booking.currentStep - 1).clamp(0, 4);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2A2A3C), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.id, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${booking.serviceName} • ${booking.vehicleName} (${booking.vehiclePlat})', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: booking.currentStep / 5.0,
            backgroundColor: Colors.grey[800],
            color: const Color(0xFFEA580C),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text('${steps[currentStepIndex]} (${booking.currentStep}/5)', style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFEA580C))),
          const SizedBox(height: 14),
          if (booking.currentStep < 5)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _advanceStep(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEA580C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Lanjut Ke Tahap Berikutnya',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
