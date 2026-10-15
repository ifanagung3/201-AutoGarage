import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  bool _notifikasi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/akun'))),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifikasi', style: GoogleFonts.poppins()),
            subtitle: Text('Aktifkan notifikasi untuk update servis', style: GoogleFonts.poppins(fontSize: 12)),
            value: _notifikasi,
            onChanged: (val) => setState(() => _notifikasi = val),
          ),
        ],
      ),
    );
  }
}
