import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';

class AccountMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const AccountMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });
}

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  List<AccountMenuItem> _getMenuItems(BuildContext context) => [
        AccountMenuItem(
          icon: Icons.person_outline_rounded,
          title: 'Data Diri',
          onTap: () => context.push('/akun/data-diri'),
        ),
        AccountMenuItem(
          icon: Icons.directions_car_outlined,
          title: 'Kendaraan Saya',
          onTap: () => context.push('/akun/kendaraan-saya'),
        ),
        AccountMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Alamat Saya',
          onTap: () => context.push('/akun/alamat-saya'),
        ),
        AccountMenuItem(
          icon: Icons.confirmation_number_outlined,
          title: 'Promo',
          onTap: () => context.push('/akun/promo'),
        ),
        AccountMenuItem(
          icon: Icons.help_outline_rounded,
          title: 'Bantuan',
          onTap: () => context.push('/akun/bantuan'),
        ),
        AccountMenuItem(
          icon: Icons.info_outline_rounded,
          title: 'Tentang Aplikasi',
          onTap: () => context.push('/akun/tentang-aplikasi'),
        ),
        AccountMenuItem(
          icon: Icons.settings_outlined,
          title: 'Pengaturan',
          onTap: () => context.push('/akun/pengaturan'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    final userName = currentUser?.displayName?.isNotEmpty == true
        ? currentUser!.displayName!
        : 'Aldy Zulhaj Islam';
    final userEmail = currentUser?.email?.isNotEmpty == true
        ? currentUser!.email!
        : 'aldy.zulhaj@email.com';

    // Generates initials like 'AZ' or 'A'
    final nameParts = userName.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : (userName.isNotEmpty ? userName[0].toUpperCase() : 'AG');

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Akun Saya',
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
          children: [
            // Profile Card Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFE85923)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.poppins(
                            color: textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: GoogleFonts.poppins(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Member Gold',
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu Items List
            ..._getMenuItems(context).map((item) => _buildMenuItem(item)),
            const SizedBox(height: 16),

            // Logout Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: TextButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    context.go('/sign-in');
                  }
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
                label: Text(
                  'Keluar',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: cardColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: cardBorderColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(AccountMenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorderColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: item.onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cardBorderColor),
                  ),
                  child: Icon(
                    item.icon,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
