// lib/screens/admin/admin_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  static const Color primaryColor = Color(0xFFEA580C); // oranye admin
  static const Color bgColor = Color(0xFF1E1E2C);
  static const Color surfaceColor = Color(0xFF2A2A3C);

  static const List<_AdminNavItem> _navItems = [
    _AdminNavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', path: '/admin'),
    _AdminNavItem(icon: Icons.calendar_month_rounded, label: 'Booking', path: '/admin/booking'),
    _AdminNavItem(icon: Icons.build_rounded, label: 'Servis', path: '/admin/servis'),
    _AdminNavItem(icon: Icons.people_rounded, label: 'Pelanggan', path: '/admin/pelanggan'),
    _AdminNavItem(icon: Icons.local_offer_rounded, label: 'Promo', path: '/admin/promo'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/admin/booking')) return 1;
    if (location.startsWith('/admin/servis')) return 2;
    if (location.startsWith('/admin/pelanggan')) return 3;
    if (location.startsWith('/admin/promo')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && currentIndex != 0) {
          context.go('/admin');
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12)],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isSelected = i == currentIndex;
                  return GestureDetector(
                    onTap: () => context.go(item.path),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(item.icon, color: isSelected ? primaryColor : Colors.grey, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? primaryColor : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminNavItem {
  final IconData icon;
  final String label;
  final String path;
  const _AdminNavItem({required this.icon, required this.label, required this.path});
}
