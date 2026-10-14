import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceHistoryItem {
  final String serviceNo;
  final String serviceName;
  final String date;
  final String status;
  final bool isCompleted;

  const ServiceHistoryItem({
    required this.serviceNo,
    required this.serviceName,
    required this.date,
    required this.status,
    required this.isCompleted,
  });
}

class RiwayatServisScreen extends StatelessWidget {
  const RiwayatServisScreen({super.key});

  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color successColor = Color(0xFF22C55E);
  static const Color waitingColor = Color(0xFF94A3B8);

  final List<ServiceHistoryItem> historyItems = const [
    ServiceHistoryItem(
      serviceNo: 'Sv-24053-001',
      serviceName: 'Servis Berkala',
      date: '23 Juli 2026',
      status: 'Selesai',
      isCompleted: true,
    ),
    ServiceHistoryItem(
      serviceNo: 'Sv-24053-002',
      serviceName: 'Ganti Oli',
      date: '23 Juli 2026',
      status: 'Selesai',
      isCompleted: true,
    ),
    ServiceHistoryItem(
      serviceNo: 'Sv-24053-003',
      serviceName: 'Overhaul Mesin',
      date: '23 Juli 2026',
      status: 'Menunggu',
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Riwayat Servis',
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
          children: historyItems.map((item) => _buildHistoryCard(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ServiceHistoryItem item) {
    final statusBadgeColor = item.isCompleted ? successColor : waitingColor;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
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
              Text(
                item.serviceNo,
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBadgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusBadgeColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  item.status,
                  style: GoogleFonts.poppins(
                    color: statusBadgeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.serviceName,
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: textSecondary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                item.date,
                style: GoogleFonts.poppins(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: cardBorderColor, height: 1),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: cardBorderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Detail',
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: textSecondary,
                    size: 16,
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
