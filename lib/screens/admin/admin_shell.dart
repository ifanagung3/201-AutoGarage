import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/admin/booking')) return 1;
    if (location.startsWith('/admin/servis')) return 2;
    if (location.startsWith('/admin/estimasi')) return 3;
    if (location.startsWith('/admin/pelanggan')) return 4;
    if (location.startsWith('/admin/promo')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          if (currentIndex != 0) {
            context.go('/admin');
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
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
                context.go('/admin/estimasi');
                break;
              case 4:
                context.go('/admin/pelanggan');
                break;
              case 5:
                context.go('/admin/promo');
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1E1E2C),
          selectedItemColor: const Color(0xFFEA580C),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_online), label: 'Booking'),
            BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Servis'),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: 'Estimasi'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Pelanggan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer), label: 'Promo'),
          ],
        ),
      ),
    );
  }
}
