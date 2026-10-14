import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Wrapper untuk semua halaman booking agar tombol back HP kembali ke Home
class BookingWrapper extends StatelessWidget {
  final Widget child;
  const BookingWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: child,
    );
  }
}
