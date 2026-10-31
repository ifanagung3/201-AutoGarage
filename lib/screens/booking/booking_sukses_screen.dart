import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_draft.dart';
import '../../models/garage_service.dart';

class BookingSuksesScreen extends StatelessWidget {
  const BookingSuksesScreen({super.key, this.draft});

  final BookingDraft? draft;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final formattedDate = draft?.bookingDate != null
        ? dateFormat.format(draft!.bookingDate!)
        : 'Tanggal telah dijadwalkan';
    final service = GarageServiceCatalog.findByName(draft?.serviceName);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.softBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Success Animated Checkmark Banner
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Booking Berhasil!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Permintaan booking Anda telah terkirim. Bengkel akan mengonfirmasi jadwal dan biaya final.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 32),

                // Booking Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.design_services_outlined,
                        label: 'Layanan',
                        value: draft?.serviceName ?? 'Servis Rutin',
                      ),
                      if (draft?.serviceOption != null) ...[
                        const Divider(height: 24),
                        _DetailRow(
                          icon: Icons.tune_rounded,
                          label: 'Opsi',
                          value: draft!.serviceOption!,
                        ),
                      ],
                      if (draft?.vehicle != null) ...[
                        const Divider(height: 24),
                        _DetailRow(
                          icon: Icons.directions_car_outlined,
                          label: 'Kendaraan',
                          value:
                              '${draft!.vehicle!.fullName} • ${draft!.vehicle!.platNumber}',
                        ),
                      ],
                      if (service != null) ...[
                        const Divider(height: 24),
                        _DetailRow(
                          icon: Icons.payments_outlined,
                          label: 'Harga katalog',
                          value: service.priceLabel,
                        ),
                      ],
                      const Divider(height: 24),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Tanggal',
                        value: formattedDate,
                      ),
                      const Divider(height: 24),
                      _DetailRow(
                        icon: Icons.access_time_outlined,
                        label: 'Waktu',
                        value: '${draft?.bookingTime ?? '09:00'} WIB',
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => context.go('/status'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3B45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Pantau Status Servis',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.go('/home'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF3B45)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Kembali ke Beranda',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF3B45),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF3B45)),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
