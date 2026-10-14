// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/create_password_screen.dart';
import '../../screens/onboarding/complete_profile_screen.dart';
import '../../screens/onboarding/allow_location_screen.dart';
import '../../screens/onboarding/allow_notification_screen.dart';
import '../../screens/main/main_shell.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/booking/booking_layanan_screen.dart';
import '../../screens/booking/booking_tanggal_screen.dart';
import '../../screens/booking/booking_waktu_screen.dart';
import '../../screens/booking/booking_konfirmasi_screen.dart';
import '../../screens/status/status_servis_screen.dart';
import '../../screens/riwayat/riwayat_servis_screen.dart';
import '../../screens/akun/akun_screen.dart';
import '../../screens/akun/data_diri_screen.dart';
import '../../screens/akun/kendaraan_saya_screen.dart';
import '../../screens/akun/alamat_saya_screen.dart';
import '../../screens/akun/promo_screen.dart';
import '../../screens/akun/bantuan_screen.dart';
import '../../screens/akun/tentang_aplikasi_screen.dart';
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
    GoRoute(path: '/', redirect: (c, s) => '/splash'),
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/sign-in', builder: (c, s) => const SignInScreen()),
    GoRoute(path: '/sign-up', builder: (c, s) => const SignUpScreen()),
    GoRoute(path: '/otp', builder: (c, s) => const OtpScreen()),
    GoRoute(path: '/forgot-password', builder: (c, s) => const ForgotPasswordScreen()),
    GoRoute(path: '/create-password', builder: (c, s) => const CreatePasswordScreen()),
    GoRoute(path: '/complete-profile', builder: (c, s) => const CompleteProfileScreen()),
    GoRoute(path: '/allow-location', builder: (c, s) => const AllowLocationScreen()),
    GoRoute(path: '/allow-notification', builder: (c, s) => const AllowNotificationScreen()),
    ShellRoute(
      builder: (c, s, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/status', builder: (c, s) => const StatusServisScreen()),
        GoRoute(path: '/riwayat', builder: (c, s) => const RiwayatServisScreen()),
        GoRoute(path: '/akun', builder: (c, s) => const AkunScreen()),
      ],
    ),
    GoRoute(path: '/booking/layanan', builder: (c, s) => const BookingLayananScreen()),
    GoRoute(path: '/booking/tanggal', builder: (c, s) => const BookingTanggalScreen()),
    GoRoute(path: '/booking/waktu', builder: (c, s) => const BookingWaktuScreen()),
    GoRoute(path: '/booking/konfirmasi', builder: (c, s) => const BookingKonfirmasiScreen()),
    GoRoute(path: '/akun/data-diri', builder: (c, s) => const DataDiriScreen()),
    GoRoute(path: '/akun/kendaraan-saya', builder: (c, s) => const KendaraanSayaScreen()),
    GoRoute(path: '/akun/alamat-saya', builder: (c, s) => const AlamatSayaScreen()),
    GoRoute(path: '/akun/promo', builder: (c, s) => const PromoScreen()),
    GoRoute(path: '/akun/bantuan', builder: (c, s) => const BantuanScreen()),
    GoRoute(path: '/akun/tentang-aplikasi', builder: (c, s) => const TentangAplikasiScreen()),
    GoRoute(path: '/akun/pengaturan', builder: (c, s) => const PengaturanScreen()),
    // Admin ShellRoute
    ShellRoute(
      builder: (c, s, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/admin', builder: (c, s) => const AdminDashboardScreen()),
        GoRoute(path: '/admin/booking', builder: (c, s) => const AdminBookingScreen()),
        GoRoute(path: '/admin/servis', builder: (c, s) => const AdminServisScreen()),
        GoRoute(path: '/admin/estimasi', builder: (c, s) => const AdminEstimasiScreen()),
        GoRoute(path: '/admin/pelanggan', builder: (c, s) => const AdminPelangganScreen()),
        GoRoute(path: '/admin/promo', builder: (c, s) => const AdminPromoScreen()),
      ],
    ),
  ],
);
