import 'package:go_router/go_router.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/booking/booking_layanan_screen.dart';
import '../../screens/booking/booking_tanggal_screen.dart';
import '../../screens/booking/booking_waktu_screen.dart';
import '../../screens/booking/booking_konfirmasi_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    
    // Booking Routes with PopScope
    GoRoute(
      path: '/booking/layanan',
      builder: (context, state) => const BookingLayananScreen(),
    ),
    GoRoute(
      path: '/booking/tanggal',
      builder: (context, state) => const BookingTanggalScreen(),
    ),
    GoRoute(
      path: '/booking/waktu',
      builder: (context, state) => const BookingWaktuScreen(),
    ),
    GoRoute(
      path: '/booking/konfirmasi',
      builder: (context, state) => const BookingKonfirmasiScreen(),
    ),
  ],
);
