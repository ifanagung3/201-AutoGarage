import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  bool _pushNotif = true;
  bool _emailNotif = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Pengaturan',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notifikasi', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Notifikasi Push', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
                  subtitle: Text('Terima pembaruan status servis', style: GoogleFonts.poppins(fontSize: 12, color: textSecondary)),
                  value: _pushNotif,
                  activeThumbColor: primaryColor,
                  onChanged: (val) => setState(() => _pushNotif = val),
                ),
                const Divider(height: 1, color: borderColor),
                SwitchListTile(
                  title: Text('Notifikasi Email', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
                  subtitle: Text('Terima promo dan struk via email', style: GoogleFonts.poppins(fontSize: 12, color: textSecondary)),
                  value: _emailNotif,
                  activeThumbColor: primaryColor,
                  onChanged: (val) => setState(() => _emailNotif = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Tampilan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: SwitchListTile(
              title: Text('Mode Gelap (Dark Mode)', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
              subtitle: Text('Gunakan tema gelap pada aplikasi', style: GoogleFonts.poppins(fontSize: 12, color: textSecondary)),
              value: _darkMode,
              activeThumbColor: primaryColor,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
          ),
        ],
      ),
    );
  }
}
