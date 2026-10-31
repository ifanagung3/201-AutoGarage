import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';

class RiwayatDetailScreen extends StatelessWidget {
  const RiwayatDetailScreen({super.key, this.booking});

  final BookingModel? booking;

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/riwayat');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    final serviceName = booking?.serviceName ?? 'Servis Berkala';
    final serviceOption = booking?.serviceOption;
    final vehicleName = booking?.vehicleName ?? 'Kendaraan';
    final vehiclePlat = booking?.vehiclePlat ?? '-';
    final bookingDate = booking != null
        ? dateFormat.format(booking!.bookingDate)
        : 'Tanggal Servis';
    final bookingTime = booking?.bookingTime ?? '09:00';
    final cost = booking?.estimatedCost ?? 0.0;
    final status = booking?.status ?? 'Selesai';
    final isCompleted = status == 'Selesai';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.softBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'Detail Riwayat Servis',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => _handleBack(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : Colors.red.shade400,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.red.shade700,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: $status',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? const Color(0xFF059669)
                                : Colors.red.shade700,
                          ),
                        ),
                        Text(
                          isCompleted
                              ? 'Pengerjaan telah selesai dilakukan'
                              : 'Pemesanan telah dibatalkan',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Service & Vehicle Detail Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Servis',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ItemRow(label: 'Jenis Layanan', value: serviceName),
                    if (serviceOption != null) ...[
                      const Divider(height: 20),
                      _ItemRow(label: 'Opsi Layanan', value: serviceOption),
                    ],
                    const Divider(height: 20),
                    _ItemRow(label: 'Kendaraan', value: vehicleName),
                    const Divider(height: 20),
                    _ItemRow(label: 'Nomor Plat', value: vehiclePlat),
                    const Divider(height: 20),
                    _ItemRow(label: 'Tanggal Servis', value: bookingDate),
                    const Divider(height: 20),
                    _ItemRow(label: 'Waktu Servis', value: '$bookingTime WIB'),
                    const Divider(height: 20),
                    _ItemRow(
                      label: 'Total Biaya',
                      value: currencyFormat.format(cost),
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Timeline Progress
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progres Timeline',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TimelineStep(
                      step: '1',
                      title: 'Penerimaan & Check-in',
                      isDone: true,
                    ),
                    _TimelineStep(
                      step: '2',
                      title: 'Pemeriksaan Awal',
                      isDone: true,
                    ),
                    _TimelineStep(
                      step: '3',
                      title: 'Pengerjaan Servis',
                      isDone: isCompleted,
                    ),
                    _TimelineStep(
                      step: '4',
                      title: 'Quality Control',
                      isDone: isCompleted,
                    ),
                    _TimelineStep(
                      step: '5',
                      title: 'Penyerahan Kendaraan',
                      isDone: isCompleted,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rebook Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/estimasi'),
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  label: Text(
                    'Booking Servis Lagi',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _ItemRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isHighlight ? 15 : 13,
            fontWeight: FontWeight.bold,
            color:
                isHighlight ? const Color(0xFFFF3B45) : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String step;
  final String title;
  final bool isDone;
  final bool isLast;

  const _TimelineStep({
    required this.step,
    required this.title,
    required this.isDone,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone ? const Color(0xFF10B981) : Colors.grey[300]!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF10B981) : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        step,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
              color: isDone ? AppColors.textPrimary : Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}
