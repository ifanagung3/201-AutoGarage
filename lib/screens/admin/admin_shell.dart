import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  DateTime? _lastPressedAt;

  int _currentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/admin/booking')) return 1;
    if (location.startsWith('/admin/servis')) return 2;
    if (location.startsWith('/admin/pelanggan')) return 3;
    if (location.startsWith('/admin/estimasi')) return 4;
    if (location.startsWith('/admin/promo')) return 5;
    return 0;
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur Admin Lainnya',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.attach_money, color: Color(0xFFF97316)),
              ),
              title: Text('Input Estimasi Biaya', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('Kelola dan sesuaikan estimasi biaya servis', style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/admin/estimasi');
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_offer, color: Color(0xFFEC4899)),
              ),
              title: Text('Kelola Kode Promo', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text('Tambah dan atur diskon promo pelanggan', style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                context.go('/admin/promo');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        if (currentIndex != 0) {
          context.go('/admin');
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tekan sekali lagi untuk keluar dari Mode Admin',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: const Color(0xFFF97316),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: widget.child,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: const Color(0xFFF97316).withValues(alpha: 0.2),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFF97316));
                }
                return GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400]);
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Color(0xFFF97316), size: 24);
                }
                return IconThemeData(color: Colors.grey[400], size: 22);
              }),
            ),
            child: NavigationBar(
              height: 68,
              backgroundColor: const Color(0xFF1E293B),
              selectedIndex: currentIndex > 3 ? 3 : currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/admin');
                    break;
                  case 1:
                    context.go('/admin/booking');
                    break;
                  case 2:
                    context.go('/admin/servis');
                    break;
                  case 3:
                    _showMoreMenu(context);
                    break;
                }
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: 'Booking',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.build_outlined),
                  selectedIcon: Icon(Icons.build_circle_rounded),
                  label: 'Servis',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded, color: currentIndex > 2 ? const Color(0xFFF97316) : Colors.grey[400]),
                  selectedIcon: const Icon(Icons.grid_view_rounded, color: Color(0xFFF97316)),
                  label: 'Lainnya',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
