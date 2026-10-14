// lib/screens/admin/admin_servis_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminServisScreen extends StatefulWidget {
  const AdminServisScreen({super.key});

  @override
  State<AdminServisScreen> createState() => _AdminServisScreenState();
}

class _AdminServisScreenState extends State<AdminServisScreen> {
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);

  final List<Map<String, dynamic>> _servisList = [
    {'id': '1', 'name': 'Rina Marlina', 'car': 'Honda Jazz', 'plate': 'B 4567 EF', 'service': 'Ganti Oli', 'step': 2},
    {'id': '2', 'name': 'Sari Dewi', 'car': 'Daihatsu Sigra', 'plate': 'D 1234 AB', 'service': 'Tune Up', 'step': 1},
    {'id': '3', 'name': 'Ahmad Fauzi', 'car': 'Suzuki Ertiga', 'plate': 'F 9876 CD', 'service': 'Ganti Ban', 'step': 3},
  ];

  final List<String> _steps = [
    'Penerimaan Kendaraan',
    'Pengecekan Awal',
    'Pengerjaan',
    'Quality Check',
    'Selesai',
  ];

  void _showStepperSheet(BuildContext context, Map<String, dynamic> servis) {
    int currentStep = servis['step'] as int;
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update Progress Servis', style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${servis['name']} — ${servis['car']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
              const SizedBox(height: 20),
              ...List.generate(_steps.length, (i) {
                final isDone = i < currentStep;
                final isCurrent = i == currentStep;
                return GestureDetector(
                  onTap: () {
                    setSheetState(() => currentStep = i + 1 <= _steps.length ? i + 1 : i);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? const Color(0xFF22C55E) : isCurrent ? primaryColor : Colors.grey.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                : Text('${i + 1}', style: GoogleFonts.poppins(color: isCurrent ? Colors.white : textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          _steps[i],
                          style: GoogleFonts.poppins(
                            color: isDone ? const Color(0xFF22C55E) : isCurrent ? primaryColor : textSecondary,
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => servis['step'] = currentStep);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Progress diperbarui: ${currentStep < _steps.length ? _steps[currentStep] : "Selesai"}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Simpan Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
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
        title: Text('Update Status Servis', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _servisList.length,
        itemBuilder: (context, index) {
          final s = _servisList[index];
          final step = s['step'] as int;
          return GestureDetector(
            onTap: () => _showStepperSheet(context, s),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.build_rounded, color: primaryColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('${s['car']} • ${s['plate']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: textSecondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(s['service'] as String, style: GoogleFonts.poppins(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: step / _steps.length,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tahap ${step < _steps.length ? step + 1 : _steps.length}: ${step < _steps.length ? _steps[step] : _steps.last}',
                    style: GoogleFonts.poppins(color: textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
