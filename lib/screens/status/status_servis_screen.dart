import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusServisScreen extends StatelessWidget {
  const StatusServisScreen({super.key});

  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Status Servis',
          style: GoogleFonts.poppins(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: cardBorderColor,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cardBorderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: cardBorderColor),
                        ),
                        child: Text(
                          'No Servis: Sv-24053-001',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Dalam Proses',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Toyota Avanza',
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'B 1234 ABC • Servis Berkala',
                    style: GoogleFonts.poppins(
                      color: textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: cardBorderColor, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '23 Juli 2026',
                            style: GoogleFonts.poppins(
                              color: textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Estimasi Biaya',
                            style: GoogleFonts.poppins(
                              color: textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Rp 350.000',
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stepper Section Title
            Text(
              'Lacak Pengerjaan',
              style: GoogleFonts.poppins(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),

            // Stepper Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cardBorderColor),
              ),
              child: Column(
                children: [
                  _buildStepItem(
                    title: 'Penerimaan Kendaraan',
                    subtitle: '23 Juli 2026 08:40',
                    state: StepStatus.done,
                    isLast: false,
                  ),
                  _buildStepItem(
                    title: 'Pengecekan Awal',
                    subtitle: '23 Juli 2026 08:40',
                    state: StepStatus.done,
                    isLast: false,
                  ),
                  _buildStepItem(
                    title: 'Pengerjaan',
                    subtitle: 'Sedang dikerjakan oleh mekanik tim',
                    state: StepStatus.inProgress,
                    isLast: false,
                  ),
                  _buildStepItem(
                    title: 'Quality Check',
                    subtitle: 'Menunggu proses selesai',
                    state: StepStatus.waiting,
                    isLast: false,
                  ),
                  _buildStepItem(
                    title: 'Selesai',
                    subtitle: 'Kendaraan siap diambil',
                    state: StepStatus.waiting,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Note Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: warningColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Harap datang 10 menit sebelum jadwal servis.',
                      style: GoogleFonts.poppins(
                        color: textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required String title,
    required String subtitle,
    required StepStatus state,
    required bool isLast,
  }) {
    Color iconBgColor;
    Color iconColor;
    Widget iconWidget;

    switch (state) {
      case StepStatus.done:
        iconBgColor = successColor.withValues(alpha: 0.18);
        iconColor = successColor;
        iconWidget = Icon(Icons.check_circle_rounded, color: iconColor, size: 22);
        break;
      case StepStatus.inProgress:
        iconBgColor = primaryColor.withValues(alpha: 0.2);
        iconColor = primaryColor;
        iconWidget = Icon(Icons.sync_rounded, color: iconColor, size: 22);
        break;
      case StepStatus.waiting:
        iconBgColor = surfaceColor;
        iconColor = textSecondary;
        iconWidget = Icon(Icons.hourglass_empty_rounded, color: iconColor, size: 20);
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator & Line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: state == StepStatus.inProgress
                        ? primaryColor
                        : state == StepStatus.done
                            ? successColor.withValues(alpha: 0.5)
                            : cardBorderColor,
                    width: 1.5,
                  ),
                ),
                child: Center(child: iconWidget),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: state == StepStatus.done
                        ? successColor.withValues(alpha: 0.5)
                        : cardBorderColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: state == StepStatus.waiting ? textSecondary : textPrimary,
                      fontSize: 14,
                      fontWeight: state == StepStatus.inProgress
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: state == StepStatus.inProgress ? primaryColor : textSecondary,
                      fontSize: 12,
                      fontWeight: state == StepStatus.inProgress
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum StepStatus {
  done,
  inProgress,
  waiting,
}
