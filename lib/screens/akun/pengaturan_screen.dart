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

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/akun');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengaturan'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
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
      ),
    );
  }
}
