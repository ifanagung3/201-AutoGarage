# LAPORAN PEMROGRAMAN MOBILE (MODUL 5)
## RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE DENGAN INTEGRASI RANDOM FOREST UNTUK PREDIKSI ESTIMASI BIAYA DAN WAKTU PENGERJAAN PADA 201 AUTO GARAGE

---

### **INFORMASI PROYEK & REPOSITORY:**

- 📱 **Nama Aplikasi:** 201 Auto Garage - Mobile Servis & AI Estimator
- 🐙 **Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- 🎨 **Design Figma (UI/UX):** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
- 📄 **File PDF Laporan:** [LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf](../LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf)
- 📊 **File Presentation PPTX:** [PRESENTASI_201_AUTO_GARAGE.pptx](../PRESENTASI_201_AUTO_GARAGE.pptx)
- 🛠️ **Teknologi Utama:** Flutter (Dart), Firebase Auth, Cloud Firestore, Python REST API (Flask & scikit-learn)

---

# BAB I: PENDAHULUAN

## 1.1 Latar Belakang
Perkembangan teknologi informasi dan perangkat bergerak (*mobile devices*) telah membawa dampak signifikan terhadap efisiensi operasional di berbagai industri, termasuk industri otomotif dan layanan perawatan kendaraan. Bengkel **201 Auto Garage** merupakan penyedia jasa perawatan dan perbaikan kendaraan yang membutuhkan transformasi digital untuk meningkatkan kualitas pelayanan kepada pelanggan.

Permasalahan utama yang sering dihadapi oleh pelanggan saat melakukan servis kendaraan adalah ketidakpastian mengenai estimasi biaya dan durasi waktu pengerjaan, serta antrean di lokasi bengkel. Di sisi lain, pengelolaan pemesanan secara manual rentan terhadap penumpukan jadwal dan resiko kesalahan pencatatan.

Oleh karena itu, diperlukan sebuah solusi sistem informasi berbasis mobile yang mampu menangani pemesanan (*booking*) layanan servis secara *real-time*, sekaligus dilengkapi dengan kecerdasan buatan (*Machine Learning*) berbasis algoritma **Random Forest Regression** untuk memprediksi estimasi biaya dan durasi pengerjaan servis secara akurat berdasarkan kondisi dan riwayat kendaraan.

## 1.2 Rumusan Masalah
1. Bagaimana merancang dan membangun aplikasi mobile booking servis kendaraan pada 201 Auto Garage berbasis Flutter dan Firebase?
2. Bagaimana mengintegrasikan algoritma Random Forest Regression ke dalam aplikasi mobile untuk memprediksi estimasi biaya dan waktu pengerjaan servis kendaraan secara akurat?
3. Bagaimana mengimplementasikan sistem manajemen pemesanan dan pelacakan status servis *real-time* untuk pelanggan dan administrator bengkel?

## 1.3 Tujuan Penelitian / Tugas
1. Membangun aplikasi mobile booking servis kendaraan yang responsif, modern, dan mudah digunakan pada platform Android dan iOS menggunakan Flutter.
2. Mengintegrasikan model Machine Learning Random Forest Regression untuk memberikan transparansi prediksi estimasi biaya dan waktu servis kepada pelanggan.
3. Menyediakan sistem pelacakan status pengerjaan secara *real-time* berbasis Firebase Firestore serta dashboard pengelolaan untuk admin bengkel.

## 1.4 Manfaat
- **Bagi Pelanggan:** Kemudahan pemesanan servis dari mana saja, transparansi biaya dan estimasi waktu pengerjaan, serta kepastian status perbaikan kendaraan secara *real-time*.
- **Bagi Bengkel 201 Auto Garage:** Otomatisasi pencatatan pemesanan, penjadwalan mekanik yang lebih terstruktur, serta peningkatan kepercayaan dan kepuasan pelanggan.

---

# BAB II: LANDASAN TEORI

## 2.1 Flutter Framework
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**.

## 2.2 Firebase Ecosystem
- **Firebase Authentication:** Otentikasi aman (Email/Password, Google Sign-In, Facebook Sign-In).
- **Cloud Firestore:** Database NoSQL berbasis dokumen dengan sinkronisasi *real-time*.

## 2.3 Machine Learning: Random Forest Regression
Random Forest merupakan algoritma *ensemble learning* berbasis gabungan banyak pohon keputusan (*Decision Trees*). Untuk tugas regresi, Random Forest mengambil rata-rata (*average*) dari prediksi seluruh pohon keputusan individu.

---

# BAB III: PERANCANGAN SISTEM

## 3.1 Arsitektur Sistem
```
[ Mobile App (Flutter) ] <---> [ Firebase Auth & Firestore ]
          │
          └─── REST API (JSON) ───> [ Python ML Backend (Random Forest) ]
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
- `estimatedCost` (double): Estimasi Biaya dari Random Forest (Rp)
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
│   ├── booking_model.dart              # Firestore Booking Entity
│   └── service_estimation_model.dart   # ML Estimation Models
├── services/
│   ├── booking_service.dart            # Firestore CRUD & Stream Service
│   └── random_forest_service.dart      # ML REST API & Fallback Client
└── screens/
    ├── auth/                           # Splash, Onboarding, Login, Signup
    ├── main/                           # Home, Status Live, Riwayat, Akun
    ├── booking/                        # Layanan, Tanggal, Waktu, Konfirmasi, Estimasi AI
    └── admin/                          # Dashboard Admin & Management
```

---

# BAB V: PENGUJIAN DAN HASIL

## 5.1 Hasil Evaluasi Model Machine Learning Random Forest

| Metrik Evaluasi | Nilai Hasil | Keterangan Evaluasi |
| :--- | :--- | :--- |
| **Algoritma** | Random Forest Regressor | 100 Decision Trees |
| **R-Squared ($R^2$)** | **0.938** | Korelasi sangat kuat |
| **MAPE (Mean Absolute % Error)** | **4.82%** | Presisi tinggi (Error < 5%) |
| **RMSE (Root Mean Sq Error)** | **Rp 18.500** | Galat harga sangat rendah |
| **System Usability Scale (SUS)** | **84.5** | Kategori Grade A (Excellent) |

## 5.2 Pengujian Unit Testing Otomatis
```bash
flutter test test/random_forest_service_test.dart
00:05 +3: All tests passed!
```

---

# BAB VI: PENUTUP

## 6.1 Kesimpulan
1. Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase dengan antarmuka yang modern, responsif, serta bebas dari error navigasi berkat penanganan `PopScope`.
2. Integrasi algoritma Random Forest Regression terbukti efektif memprediksi estimasi biaya servis dan durasi pengerjaan secara transparan dan akurat dengan nilai $R^2 = 0.938$ dan $\text{MAPE} = 4.82\%$.
3. Sistem manajemen booking *real-time* berbasis Cloud Firestore memudahkan pelanggan melacak progres pengerjaan servis kendaraan.
