import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_draft.dart';

class BookingTanggalScreen extends StatefulWidget {
  const BookingTanggalScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingTanggalScreen> createState() => _BookingTanggalScreenState();
}

class _BookingTanggalScreenState extends State<BookingTanggalScreen> {
  DateTime? selectedDate;

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/booking/layanan', extra: widget.draft);
    }
  }

  /// Returns true if the date should be blocked (Sunday or > 30 days from now).
  bool _isBlocked(DateTime day) {
    return day.weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1)); // minimum D+1
    final lastDate = now.add(const Duration(days: 30));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.softBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'Pilih Tanggal',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: Text(
                'Bengkel buka Senin – Sabtu. Hari Minggu tidak tersedia.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Expanded(
              child: CalendarDatePicker(
                initialDate: firstDate,
                firstDate: firstDate,
                lastDate: lastDate,
                selectableDayPredicate: (day) => !_isBlocked(day),
                onDateChanged: (date) => setState(() => selectedDate = date),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedDate == null
                      ? null
                      : () => context.push(
                            '/booking/waktu',
                            extra: widget.draft.copyWith(
                              bookingDate: selectedDate,
                            ),
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    'Lanjut',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
