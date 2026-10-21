import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Profile
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B8DEF), Color(0xFF3872E0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: user?.photoURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              user!.photoURL!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person,
                                      size: 40, color: Color(0xFF5B8DEF)),
                            ),
                          )
                        : const Icon(Icons.person,
                            size: 40, color: Color(0xFF5B8DEF)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _MenuCard(
                    icon: Icons.person_outline,
                    title: 'Data Diri',
                    color: const Color(0xFF5B8DEF),
                    onTap: () => context.go('/akun/data-diri'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.directions_car_outlined,
                    title: 'Kendaraan Saya',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => context.go('/akun/kendaraan'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.location_on_outlined,
                    title: 'Alamat Saya',
                    color: const Color(0xFF10B981),
                    onTap: () => context.go('/akun/alamat'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.local_offer_outlined,
                    title: 'Promo',
                    color: const Color(0xFFEC4899),
                    onTap: () => context.go('/akun/promo'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    color: const Color(0xFFF59E0B),
                    onTap: () => context.go('/akun/bantuan'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.info_outline,
                    title: 'Tentang',
                    color: const Color(0xFF06B6D4),
                    onTap: () => context.go('/akun/tentang'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    color: const Color(0xFF64748B),
                    onTap: () => context.go('/akun/pengaturan'),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) context.go('/sign-in');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: Color(0xFFEF4444)),
                          const SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
