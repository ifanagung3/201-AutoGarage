import 'package:go_router/go_router.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/onboarding_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/complete_profile_screen.dart';
import '../../screens/main/main_shell.dart';
import '../../screens/main/home_screen.dart';
import '../../screens/main/status_servis_screen.dart';
import '../../screens/main/riwayat_servis_screen.dart';
import '../../screens/main/akun_screen.dart';
import '../../screens/booking/booking_layanan_screen.dart';
import '../../screens/booking/booking_tanggal_screen.dart';
import '../../screens/booking/booking_waktu_screen.dart';
import '../../screens/booking/booking_konfirmasi_screen.dart';
import '../../screens/akun/data_diri_screen.dart';
import '../../screens/akun/kendaraan_saya_screen.dart';
import '../../screens/akun/alamat_saya_screen.dart';
import '../../screens/akun/promo_screen.dart';
import '../../screens/akun/bantuan_screen.dart';
import '../../screens/akun/tentang_screen.dart';
import '../../screens/akun/pengaturan_screen.dart';
import '../../screens/admin/admin_shell.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_booking_screen.dart';
import '../../screens/admin/admin_servis_screen.dart';
import '../../screens/admin/admin_estimasi_screen.dart';
import '../../screens/admin/admin_pelanggan_screen.dart';
import '../../screens/admin/admin_promo_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
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
    GoRoute(
      path: '/complete-profile',
      builder: (context, state) => const CompleteProfileScreen(),
    ),
    
    // Main Shell Routes (User)
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/status',
          builder: (context, state) => const StatusServisScreen(),
        ),
        GoRoute(
          path: '/riwayat',
          builder: (context, state) => const RiwayatServisScreen(),
        ),
        GoRoute(
          path: '/akun',
          builder: (context, state) => const AkunScreen(),
          routes: [
            GoRoute(
              path: 'data-diri',
              builder: (context, state) => const DataDiriScreen(),
            ),
            GoRoute(
              path: 'kendaraan',
              builder: (context, state) => const KendaraanSayaScreen(),
            ),
            GoRoute(
              path: 'alamat',
              builder: (context, state) => const AlamatSayaScreen(),
            ),
            GoRoute(
              path: 'promo',
              builder: (context, state) => const PromoScreen(),
            ),
            GoRoute(
              path: 'bantuan',
              builder: (context, state) => const BantuanScreen(),
            ),
            GoRoute(
              path: 'tentang',
              builder: (context, state) => const TentangScreen(),
            ),
            GoRoute(
              path: 'pengaturan',
              builder: (context, state) => const PengaturanScreen(),
            ),
          ],
        ),
      ],
    ),

    // Booking Routes (dengan PopScope di dalam masing-masing screen)
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

    // Admin Shell Routes
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/booking',
          builder: (context, state) => const AdminBookingScreen(),
        ),
        GoRoute(
          path: '/admin/servis',
          builder: (context, state) => const AdminServisScreen(),
        ),
        GoRoute(
          path: '/admin/estimasi',
          builder: (context, state) => const AdminEstimasiScreen(),
        ),
        GoRoute(
          path: '/admin/pelanggan',
          builder: (context, state) => const AdminPelangganScreen(),
        ),
        GoRoute(
          path: '/admin/promo',
          builder: (context, state) => const AdminPromoScreen(),
        ),
      ],
    ),
  ],
);
