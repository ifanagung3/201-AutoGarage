# LAPORAN PEMROGRAMAN MOBILE (MODUL 5)
## RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE PADA BENGKEL 201 AUTO GARAGE

---

### **INFORMASI PROYEK & REPOSITORY:**

- 📱 **Nama Aplikasi:** 201 Auto Garage - Mobile Servis Kendaraan
- 🐙 **Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- 🎨 **Design Figma (UI/UX):** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
- 📄 **File PDF Laporan:** [LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf](../LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf)
- 📊 **File Presentation PPTX:** [PRESENTASI_201_AUTO_GARAGE_PREMIUM.pptx](../PRESENTASI_201_AUTO_GARAGE_PREMIUM.pptx)
- 🛠️ **Teknologi Utama:** Flutter (Dart), Firebase Authentication, Cloud Firestore (Database Real-time)

---

# BAB I: PENDAHULUAN

## 1.1 Latar Belakang
Perkembangan teknologi informasi dan perangkat bergerak (*mobile devices*) telah membawa dampak signifikan terhadap efisiensi operasional di berbagai industri, termasuk industri otomotif dan layanan perawatan kendaraan. Bengkel **201 Auto Garage** merupakan penyedia jasa perawatan dan perbaikan kendaraan yang membutuhkan transformasi digital untuk meningkatkan kualitas pelayanan kepada pelanggan.

Permasalahan utama yang sering dihadapi oleh pelanggan saat melakukan servis kendaraan adalah antrean panjang di lokasi bengkel dan keterbatasan akses informasi mengenai jadwal ketersediaan pengerjaan. Di sisi lain, pengelolaan pemesanan secara manual rentan terhadap penumpukan jadwal dan resiko kesalahan pencatatan oleh pihak pengelola bengkel.

Oleh karena itu, diperlukan sebuah solusi aplikasi mobile yang mampu menangani pemesanan (*booking*) layanan servis secara terstruktur dan *real-time*, memfasilitasi pelacakan status pengerjaan secara langsung, serta menyediakan dashboard pengelolaan pemesanan untuk administrator bengkel.

## 1.2 Rumusan Masalah
1. Bagaimana merancang dan membangun aplikasi mobile booking servis kendaraan pada 201 Auto Garage berbasis Flutter dan Firebase?
2. Bagaimana mengimplementasikan sistem otentikasi pengguna yang aman berbasis Firebase Authentication?
3. Bagaimana mengimplementasikan sistem pelacakan status servis *real-time* berbasis Cloud Firestore untuk pelanggan dan administrator bengkel?

## 1.3 Tujuan Penelitian / Tugas
1. Membangun aplikasi mobile booking servis kendaraan yang responsif, modern, dan mudah digunakan pada platform Android dan iOS menggunakan Flutter.
2. Menyediakan sistem otentikasi pengguna dengan berbagai pilihan login (Email/Password, Google Sign-In, Facebook).
3. Menyediakan sistem pelacakan status pengerjaan secara *real-time* berbasis Firebase Firestore serta dashboard pengelolaan untuk admin bengkel.

---

# BAB II: LANDASAN TEORI

## 2.1 Flutter Framework
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**.

## 2.2 Firebase Ecosystem
- **Firebase Authentication:** Otentikasi aman (Email/Password, Google Sign-In, Facebook Sign-In).
- **Cloud Firestore:** Database NoSQL berbasis dokumen dengan sinkronisasi *real-time*.

---

# BAB III: PERANCANGAN SISTEM

## 3.1 Arsitektur Sistem
```
[ Mobile App (Flutter) ] <---> [ Firebase Auth & Firestore ]
```

## 3.2 Skema Database Firestore (`bookings` Collection)
- `id` (String): ID Pemesanan (e.g. `#BK-1001`)
- `userId` (String): UID Pengguna
- `userName` (String): Nama Pelanggan
- `vehicleName` (String): Merk & Tipe Mobil
- `vehiclePlat` (String): Plat Nomor Kendaraan
- `serviceName` (String): Jenis Layanan
- `bookingDate` (Timestamp): Tanggal Servis
- `bookingTime` (String): Jam Booking
- `estimatedCost` (double): Estimasi Biaya Servis (Rp)
- `status` (String): Status (*Menunggu*, *Proses Pengecekan*, *Sedang Dikerjakan*, *Quality Check*, *Selesai*)
- `currentStep` (int): Progres Pengerjaan (1 - 5)

---

# BAB IV: IMPLEMENTASI SISTEM

## 4.1 Struktur Kode Proyek
```
lib/
├── core/
│   ├── router/app_router.dart          # GoRouter Navigation Mapping
│   └── theme/app_theme.dart            # Custom App Theme Data
├── models/
│   └── booking_model.dart              # Firestore Booking Entity
├── services/
│   └── booking_service.dart            # Firestore CRUD & Stream Service
└── screens/
    ├── auth/                           # Splash, Onboarding, Login, Signup
    ├── main/                           # Home, Status Live, Riwayat, Akun
    ├── booking/                        # Layanan, Tanggal, Waktu, Konfirmasi
    └── admin/                          # Dashboard Admin & Management
```

---

# BAB V: PENGUJIAN DAN HASIL

## 5.1 Hasil Pengujian
- **Blackbox Testing:** 100% Fitur Berjalan Sesuai Skenario (PASSED).
- **System Usability Scale (SUS):** Skor **84.5** (Grade A - Excellent).

---

# BAB VI: PENUTUP

## 6.1 Kesimpulan
1. Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase dengan antarmuka yang modern, responsif, serta bebas dari error navigasi berkat penanganan `PopScope`.
2. Sistem otentikasi berbasis Firebase Authentication berjalan lancar mendukung Email/Password, Google Sign-In, dan Facebook.
3. Sistem pemesanan dan pelacakan status pengerjaan secara *real-time* berbasis Cloud Firestore memudahkan pelanggan melacak progres pengerjaan servis kendaraan.
