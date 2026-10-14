// lib/screens/admin/admin_promo_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPromoScreen extends StatefulWidget {
  const AdminPromoScreen({super.key});

  @override
  State<AdminPromoScreen> createState() => _AdminPromoScreenState();
}

class _AdminPromoScreenState extends State<AdminPromoScreen> {
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);
  static const Color primaryColor = Color(0xFFEA580C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color inputFill = Color(0xFF353548);

  final List<Map<String, dynamic>> _promos = [
    {'title': 'Servis Berkala Hemat', 'code': 'GARAGE20', 'discount': '20%', 'expiry': '31 Des 2026', 'isActive': true},
    {'title': 'Gratis Cek Kaki-Kaki', 'code': 'FREECHECK', 'discount': '100%', 'expiry': '30 Nov 2026', 'isActive': true},
    {'title': 'Cashback Servis AC', 'code': 'ACCOOL50', 'discount': 'Rp 50rb', 'expiry': '15 Nov 2026', 'isActive': false},
    {'title': 'Diskon Tune Up', 'code': 'TUNEUP15', 'discount': '15%', 'expiry': '20 Okt 2026', 'isActive': true},
  ];

  void _showAddPromoDialog() {
    final titleController = TextEditingController();
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    final expiryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text('Tambah Promo Baru', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(titleController, 'Judul Promo'),
              const SizedBox(height: 10),
              _buildDialogField(codeController, 'Kode Promo (misal: HEMAT20)'),
              const SizedBox(height: 10),
              _buildDialogField(discountController, 'Diskon (misal: 20% atau Rp 50rb)'),
              const SizedBox(height: 10),
              _buildDialogField(expiryController, 'Berlaku Hingga (misal: 31 Des 2026)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: GoogleFonts.poppins(color: textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && codeController.text.isNotEmpty) {
                setState(() {
                  _promos.add({
                    'title': titleController.text,
                    'code': codeController.text.toUpperCase(),
                    'discount': discountController.text,
                    'expiry': expiryController.text,
                    'isActive': true,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Promo berhasil ditambahkan!'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: Text('Simpan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(color: textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFill,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: textSecondary, fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text('Hapus Promo?', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold)),
        content: Text('Promo "${_promos[index]['title']}" akan dihapus permanen.', style: GoogleFonts.poppins(color: textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: GoogleFonts.poppins(color: textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _promos.removeAt(index));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Promo dihapus.'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text('Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
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
        title: Text('Kelola Promo', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _promos.length,
        itemBuilder: (context, index) {
          final p = _promos[index];
          final isActive = p['isActive'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? primaryColor.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(p['title'] as String, style: GoogleFonts.poppins(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: primaryColor,
                      onChanged: (val) => setState(() => p['isActive'] = val),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => _confirmDelete(index),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(p['code'] as String, style: GoogleFonts.poppins(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Diskon ${p['discount']}', style: GoogleFonts.poppins(color: const Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: textSecondary, size: 13),
                    const SizedBox(width: 4),
                    Text('Berlaku s/d ${p['expiry']}', style: GoogleFonts.poppins(color: textSecondary, fontSize: 12)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF22C55E).withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'Aktif' : 'Nonaktif',
                        style: GoogleFonts.poppins(color: isActive ? const Color(0xFF22C55E) : textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPromoDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Promo', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
