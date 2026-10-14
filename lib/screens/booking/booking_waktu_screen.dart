import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class BookingWaktuScreen extends StatefulWidget {
  const BookingWaktuScreen({super.key});

  @override
  State<BookingWaktuScreen> createState() => _BookingWaktuScreenState();
}

class _BookingWaktuScreenState extends State<BookingWaktuScreen> {
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  int _selectedSlotIndex = 0;

  final List<Map<String, dynamic>> _timeSlots = [
    {'time': '09.00 - 10.30', 'status': 'Tersedia'},
    {'time': '10.30 - 12.00', 'status': 'Tersedia'},
    {'time': '13.00 - 14.30', 'status': 'Tersedia'},
    {'time': '14.30 - 16.00', 'status': 'Tersedia'},
    {'time': '16.00 - 17.30', 'status': 'Tersedia'},
  ];

  Widget _buildStepIndicator() {
    final steps = ['Pilih Layanan', 'Pilih Tanggal', 'Konfirmasi'];
    const currentStep = 2; // Last stage before summary

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIdx = index ~/ 2;
            final isDone = stepIdx < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isDone ? primaryColor : cardBorderColor,
              ),
            );
          }

          final stepIdx = index ~/ 2;
          final isActive = stepIdx == currentStep;
          final isDone = stepIdx < currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? primaryColor
                      : (isDone ? primaryColor.withValues(alpha: 0.2) : surfaceColor),
                  border: Border.all(
                    color: isActive || isDone ? primaryColor : cardBorderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: primaryColor)
                      : Text(
                          '${stepIdx + 1}',
                          style: GoogleFonts.poppins(
                            color: isActive ? Colors.white : textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIdx],
                style: GoogleFonts.poppins(
                  color: isActive ? primaryColor : (isDone ? textPrimary : textSecondary),
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/booking/tanggal');
            }
          },
        ),
        title: Text(
          'Pilih Waktu',
          style: GoogleFonts.poppins(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: cardBorderColor, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Pilih Jadwal Kedatangan',
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _timeSlots.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final slot = _timeSlots[index];
                  final isSelected = _selectedSlotIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSlotIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? primaryColor : cardBorderColor,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: isSelected ? Colors.white : primaryColor,
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                slot['time'] as String,
                                style: GoogleFonts.poppins(
                                  color: isSelected ? Colors.white : textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              slot['status'] as String,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : const Color(0xFF4EBE73),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: cardBorderColor)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    context.go('/booking/konfirmasi');
                  },
                  child: Text(
                    'Lanjut',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
