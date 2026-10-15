import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Akun Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(radius: 32, backgroundColor: const Color(0xFF3B82F6), child: Text(user?.displayName?.substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(fontSize: 24, color: Colors.white))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName ?? 'User', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(user?.email ?? '', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _MenuItem(icon: Icons.person, title: 'Data Diri', onTap: () => context.go('/akun/data-diri')),
          _MenuItem(icon: Icons.directions_car, title: 'Kendaraan Saya', onTap: () => context.go('/akun/kendaraan')),
          _MenuItem(icon: Icons.location_on, title: 'Alamat Saya', onTap: () => context.go('/akun/alamat')),
          _MenuItem(icon: Icons.local_offer, title: 'Promo', onTap: () => context.go('/akun/promo')),
          _MenuItem(icon: Icons.help, title: 'Bantuan', onTap: () => context.go('/akun/bantuan')),
          _MenuItem(icon: Icons.info, title: 'Tentang Aplikasi', onTap: () => context.go('/akun/tentang')),
          _MenuItem(icon: Icons.settings, title: 'Pengaturan', onTap: () => context.go('/akun/pengaturan')),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/sign-in');
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3B82F6)),
        title: Text(title, style: GoogleFonts.poppins()),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
