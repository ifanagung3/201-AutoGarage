import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class AdminServisScreen extends StatelessWidget {
  const AdminServisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: Text('Update Tahap Servis',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingService.instance.streamAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF3B45)));
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
                  Icon(Icons.build_circle_outlined,
                      size: 60, color: Colors.grey[600]),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada servis aktif saat ini',
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: AppColors.textMuted),
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

    await BookingService.instance
        .updateBookingStatus(booking.id, nextStatus, nextStep);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Tahap servis ${booking.id} berhasil diupdate ke $nextStatus!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentStepIndex = (booking.currentStep - 1).clamp(0, 4);
    final displayId = booking.id.length > 10
        ? '#${booking.id.substring(0, 8)}...'
        : booking.id;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
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
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B45).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF3B45)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
              '${booking.serviceName}${booking.serviceOption == null ? '' : ' • ${booking.serviceOption}'} • ${booking.vehicleName} (${booking.vehiclePlat})',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: booking.currentStep / 5.0,
              backgroundColor: AppColors.outline,
              color: const Color(0xFFFF3B45),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tahap: ${steps[currentStepIndex]}',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF3B45)),
              ),
              Text(
                '(${booking.currentStep}/5)',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (booking.currentStep < 5)
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _advanceStep(context),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'Lanjut Ke Tahap Berikutnya',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
