import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/theme/app_colors.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    // Sign out both Firebase Auth AND Google Sign-In so the account
    // picker appears on the next Google login instead of auto-signing in.
    await Future.wait([
      FirebaseAuth.instance.signOut(),
      GoogleSignIn().signOut(),
    ]);
    if (context.mounted) context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.softBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kelola profil dan preferensi Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      border: Border.all(color: AppColors.outline),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              AppColors.accentRed.withValues(alpha: 0.1),
                          child: user?.photoURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    user!.photoURL!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.person,
                                            size: 30,
                                            color: AppColors.accentRed),
                                  ),
                                )
                              : const Icon(Icons.person,
                                  size: 30, color: AppColors.accentRed),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _MenuCard(
                    icon: Icons.person_outline,
                    title: 'Data Diri',
                    onTap: () => context.go('/akun/data-diri'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.assignment_outlined,
                    title: 'Status Servis Saya',
                    onTap: () => context.go('/status'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.history,
                    title: 'Riwayat Servis',
                    onTap: () => context.go('/riwayat'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.directions_car_outlined,
                    title: 'Kendaraan Saya',
                    onTap: () => context.go('/akun/kendaraan'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.location_on_outlined,
                    title: 'Alamat Saya',
                    onTap: () => context.go('/akun/alamat'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.local_offer_outlined,
                    title: 'Promo',
                    onTap: () => context.go('/akun/promo'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    onTap: () => context.go('/akun/bantuan'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.info_outline,
                    title: 'Tentang',
                    onTap: () => context.go('/akun/tentang'),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    onTap: () => context.go('/akun/pengaturan'),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _signOut(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.accentRed),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: AppColors.accentRed),
                          const SizedBox(width: 8),
                          Text(
                            'Keluar',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentRed,
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
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
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
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                color: AppColors.accentRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.accentRed, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
