// lib/screens/admin/admin_estimasi_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminEstimasiScreen extends StatefulWidget {
  const AdminEstimasiScreen({super.key});

  @override
  State<AdminEstimasiScreen> createState() => _AdminEstimasiScreenState();
}

class _AdminEstimasiScreenState extends State<AdminEstimasiScreen> {
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color inputFill = Color(0xFF353548);

  final List<Map<String, dynamic>> _bookings = [
    {'id': '1', 'name': 'Budi Santoso', 'car': 'Toyota Avanza', 'service': 'Servis Berkala', 'hasEstimasi': false, 'estimasi': 0},
    {'id': '2', 'name': 'Rina Marlina', 'car': 'Honda Jazz', 'service': 'Ganti Oli', 'hasEstimasi': true, 'estimasi': 350000},
    {'id': '3', 'name': 'Sari Dewi', 'car': 'Daihatsu Sigra', 'service': 'Tune Up', 'hasEstimasi': false, 'estimasi': 0},
  ];

  void _showEstimasiSheet(BuildContext context, Map<String, dynamic> booking) {
    final sparepartController = TextEditingController();
    final jasaController = TextEditingController();
    final catatanController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          int total = 0;
          final sparepart = int.tryParse(sparepartController.text.replaceAll('.', '')) ?? 0;
          final jasa = int.tryParse(jasaController.text.replaceAll('.', '')) ?? 0;
          total = sparepart + jasa;

          return Padding(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input Estimasi Biaya', style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${booking['name']} — ${booking['service']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
                const SizedBox(height: 20),
                Text('Biaya Suku Cadang (Rp)', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: sparepartController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.poppins(color: textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputFill,
                    hintText: 'Contoh: 150000',
                    hintStyle: GoogleFonts.poppins(color: textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => setSheetState(() {}),
                ),
                const SizedBox(height: 12),
                Text('Biaya Jasa (Rp)', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: jasaController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.poppins(color: textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputFill,
                    hintText: 'Contoh: 200000',
                    hintStyle: GoogleFonts.poppins(color: textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => setSheetState(() {}),
                ),
                const SizedBox(height: 12),
                Text('Catatan (opsional)', style: GoogleFonts.poppins(color: textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: catatanController,
                  style: GoogleFonts.poppins(color: textPrimary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputFill,
                    hintText: 'Contoh: Ganti filter oli merek X',
                    hintStyle: GoogleFonts.poppins(color: textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Estimasi:', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
                      Text(
                        'Rp ${_formatRupiah(total)}',
                        style: GoogleFonts.poppins(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        booking['hasEstimasi'] = true;
                        booking['estimasi'] = total;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Estimasi Rp ${_formatRupiah(total)} berhasil disimpan!'),
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
                    child: Text('Simpan Estimasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if ((s.length - i) % 3 == 0 && i != 0) result.write('.');
      result.write(s[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text('Estimasi Biaya', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final b = _bookings[index];
          final hasEstimasi = b['hasEstimasi'] as bool;
          return GestureDetector(
            onTap: () => _showEstimasiSheet(context, b),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasEstimasi ? const Color(0xFF22C55E).withValues(alpha: 0.4) : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: (hasEstimasi ? const Color(0xFF22C55E) : primaryColor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasEstimasi ? Icons.check_circle_rounded : Icons.receipt_long_rounded,
                      color: hasEstimasi ? const Color(0xFF22C55E) : primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b['name'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                        Text('${b['car']} • ${b['service']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                        if (hasEstimasi) ...[
                          const SizedBox(height: 4),
                          Text('Rp ${_formatRupiah(b['estimasi'] as int)}', style: GoogleFonts.poppins(color: const Color(0xFF22C55E), fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (hasEstimasi ? const Color(0xFF22C55E) : primaryColor).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      hasEstimasi ? 'Ditetapkan' : 'Belum',
                      style: GoogleFonts.poppins(
                        color: hasEstimasi ? const Color(0xFF22C55E) : primaryColor,
                        fontSize: 11, fontWeight: FontWeight.w600,
                      ),
                    ),
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
