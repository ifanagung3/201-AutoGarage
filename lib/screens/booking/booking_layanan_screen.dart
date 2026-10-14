import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class BookingLayananScreen extends StatefulWidget {
  const BookingLayananScreen({super.key});

  @override
  State<BookingLayananScreen> createState() => _BookingLayananScreenState();
}

class _BookingLayananScreenState extends State<BookingLayananScreen> {
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  int _selectedServiceIndex = 0;

  final List<Map<String, dynamic>> _services = [
    {
      'icon': '🔧',
      'title': 'Servis Berkala',
      'price': 'Rp 350.000',
      'desc': 'Pemeriksaan rutin komponen vital, filter oli, busi, dan sistem rem.',
    },
    {
      'icon': '🛢️',
      'title': 'Ganti Oli',
      'price': 'Rp 150.000',
      'desc': 'Penggantian oli mesin full synthetic & filter oli orisinil.',
    },
    {
      'icon': '⚙️',
      'title': 'Overhaul Mesin',
      'price': 'Rp 350.000',
      'desc': 'Pembongkaran dan peremajaan menyeluruh ruang bakar mesin.',
    },
    {
      'icon': '🔌',
      'title': 'Tuning ECU',
      'price': 'Rp 350.000',
      'desc': 'Optimasi mapping sistem injeksi dan tenaga mesin via software.',
    },
  ];

  Widget _buildStepIndicator() {
    final steps = ['Pilih Layanan', 'Pilih Tanggal', 'Konfirmasi'];
    const currentStep = 0;

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
                  color: isActive ? primaryColor : textSecondary,
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
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Pilih Layanan',
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _services.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final service = _services[index];
                  final isSelected = _selectedServiceIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? primaryColor : cardBorderColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cardBorderColor),
                            ),
                            child: Center(
                              child: Text(
                                service['icon'] as String,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        service['title'] as String,
                                        style: GoogleFonts.poppins(
                                          color: textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? primaryColor : textSecondary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                              child: Container(
                                                width: 12,
                                                height: 12,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service['price'] as String,
                                  style: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  service['desc'] as String,
                                  style: GoogleFonts.poppins(
                                    color: textSecondary,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ],
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
                    context.go('/booking/tanggal');
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
