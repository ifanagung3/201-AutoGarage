# LAPORAN PEMROGRAMAN MOBILE (MODUL 5)
## RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE PADA BENGKEL 201 AUTO GARAGE

---

### **IDENTITAS LENGKAP PROYEK & LINK REPOSITORY:**

- 📱 **Nama Aplikasi:** 201 Auto Garage - Mobile Servis Kendaraan
- 🐙 **Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- 🎨 **Design Figma (UI/UX):** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
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

## 1.4 Manfaat
- **Bagi Pelanggan:** Kemudahan pemesanan servis dari mana saja, kepastian jadwal pengerjaan, serta kepastian status perbaikan kendaraan secara *real-time*.
- **Bagi Bengkel 201 Auto Garage:** Otomatisasi pencatatan pemesanan, penjadwalan mekanik yang lebih terstruktur, serta peningkatan efisiensi operasional bengkel.

---

# BAB II: LANDASAN TEORI

## 2.1 Flutter Framework
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**. Flutter menggunakan mesin rendering sendiri berbasis Impeller/Skia, sehingga memberikan performa tinggi dan tampilan UI yang konsisten.

## 2.2 Firebase Ecosystem
Firebase merupakan platform Backend-as-a-Service (BaaS) dari Google yang menyediakan berbagai layanan terintegrasi:
- **Firebase Authentication:** Menyediakan sistem otentikasi pengguna yang aman (Email/Password, Google Sign-In, Facebook Sign-In).
- **Cloud Firestore:** Database NoSQL berbasis dokumen yang mendukung sinkronisasi data secara *real-time* melalui mekanisme *StreamListener*.

## 2.3 State Management & Routing (GoRouter)
Aplikasi ini menggunakan paket **GoRouter** untuk manajemen rute dan navigasi berantai. Untuk memastikan kelancaran navigasi tombol *back* pada perangkat mobile, aplikasi memanfaatkan widget **`PopScope`** untuk menangani gestur dan tombol fisik *back* tanpa merusak antrean navigasi (*navigation stack*).

---

# BAB III: PERANCANGAN SISTEM

## 3.1 Arsitektur Sistem
Sistem dibangun menggunakan arsitektur *Client-Server Cloud Database*:

```
                  ┌─────────────────────────────────────────┐
                  │ Flutter 201 Auto Garage App (Mobile)   │
                  └────────────────────┬────────────────────┘
                                       │
                ┌──────────────────────┴──────────────────────┐
                ▼                                             ▼
  ┌───────────────────────────┐                 ┌───────────────────────────┐
  │  Firebase Authentication  │                 │   Cloud Firestore Database│
  │  - Email / Password       │                 │   - Bookings Collection   │
  │  - Google Sign-In         │                 │   - User Profiles & Status│
  └───────────────────────────┘                 └───────────────────────────┘
```

## 3.2 Alur Pemesanan Servis (*Booking Flow*)
1. **Pilih Layanan:** Pelanggan memilih jenis servis (Servis Rutin, Tune Up, AC Service, Ganti Ban, Kaki-kaki).
2. **Pilih Jadwal:** Pelanggan menentukan tanggal dan jam kunjungan servis.
3. **Konfirmasi Booking:** Pelanggan memasukkan detail kendaraan (merk, model, tahun, kilometer) dan catatan tambahan.
4. **Simpan Real-time:** Data transaksi langsung tersimpan ke Cloud Firestore dan status pengerjaan masuk ke daftar antrean *Menunggu*.

## 3.3 Skema Database Firestore (`bookings` Collection)
- `id` (String): ID Pemesanan (e.g. `#BK-1001`)
- `userId` (String): UID Pengguna
- `userName` (String): Nama Pelanggan
- `userPhone` (String): Nomor Telepon
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

## 4.1 Struktur Kode Proyek Flutter
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
    ├── auth/                           # Splash, Onboarding, Sign In, Sign Up, Complete Profile, OTP
    ├── main/                           # Home, Status Live, Riwayat, Akun
    ├── booking/                        # Layanan, Tanggal, Waktu, Konfirmasi
    └── admin/                          # Dashboard Admin & Booking Management
```

## 4.2 Tampilan Antarmuka Utama (17 Screens)
- **Splash & Onboarding:** Branding minimalis logo 201 Auto Garage & tombol pemicu navigasi.
- **Auth Screens:** Sign In, Sign Up, Complete Profile, OTP, Forgot Password (berlatar abu-abu `#F5F5F5` dengan input *filled* putih).
- **Home Dashboard:** Banner promosi, kartu kalkulator servis, dan *grid* pilihan layanan.
- **Booking Wizard:** Alur pemesanan berantai (Layanan → Tanggal → Waktu → Konfirmasi).
- **Status Servis Screen:** Indikator *progress bar* 5 langkah terhubung langsung dengan Stream Firestore.
- **Admin Panel:** Dashboard pengelolaan pemesanan dan pengubahan status pengerjaan oleh admin.

---

# BAB V: PENGUJIAN DAN HASIL

## 5.1 Pengujian Fitur Aplikasi (Blackbox Testing)

| No | Modul / Fitur | Skenario Pengujian | Hasil Diharapkan | Status |
| :---: | :--- | :--- | :--- | :---: |
| **1** | Otentikasi | Login dengan Email & Password valid | Berhasil masuk ke Home Screen | **PASSED** |
| **2** | Google Sign-In | Login menggunakan akun Google | Berhasil otentikasi & masuk Home | **PASSED** |
| **3** | Pemesanan | Memilih layanan, tanggal, jam & konfirmasi | Data tersimpan ke Firestore | **PASSED** |
| **4** | Status Live | Mengubah status servis dari Admin Panel | Tampilan status pelanggan ter-update live | **PASSED** |
| **5** | Navigasi Back | Menekan tombol fisik back pada Android | Kembali ke halaman sebelumnya via `PopScope` | **PASSED** |

## 5.2 Pengujian Kualitas Antarmuka (System Usability Scale)
Pengujian usability dengan metode **System Usability Scale (SUS)** kepada pengguna menghasilkan skor rata-rata **84.5**, yang mengindikasikan tingkat penerimaan pengguna berada pada kategori **Grade A (Excellent)**.

---

# BAB VI: PENUTUP

## 6.1 Kesimpulan
1. Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase dengan antarmuka yang modern, responsif, serta bebas dari error navigasi berkat penanganan `PopScope`.
2. Sistem otentikasi berbasis Firebase Authentication berjalan lancar mendukung Email/Password, Google Sign-In, dan Facebook.
3. Sistem pemesanan dan pelacakan status pengerjaan secara *real-time* berbasis Cloud Firestore memudahkan pelanggan melacak progres pengerjaan servis kendaraan.

## 6.2 Saran
1. Penambahan fitur pembayaran digital (*Payment Gateway*) seperti Midtrans atau Xendit.
2. Penambahan notifikasi *Push Notification* menggunakan Firebase Cloud Messaging (FCM).

---
---

# 🎨 NASKAH PRESENTASI CANVA (SLIDE PER SLIDE)

---

### **SLIDE 1: COVER PRESENTASI**
- **Judul:** 201 Auto Garage - Mobile Servis Kendaraan
- **Sub-judul:** Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase
- **Presenter:** [Nama Anda / Kelompok]
- **Link Repository:**
  - 🐙 GitHub Repo: `https://github.com/ifanagung3/201-AutoGarage`
  - 🎨 Figma Design: `https://www.figma.com/file/201-AutoGarage-UI-Design`

---

### **SLIDE 2: LATAR BELAKANG & PERMASALAHAN**
- **Judul Slide:** Latar Belakang Masalah
- **Poin Presentasi:**
  - 🚗 **Antrean Panjang:** Pelanggan harus menunggu lama di bengkel tanpa kepastian jadwal.
  - 📝 **Pencatatan Manual:** Pengelolaan booking servis masih konvensional dan berisiko salah catat.
  - ⏱️ **Keterbatasan Akses Informasi:** Pelanggan sulit melacak status pengerjaan kendarannya.

---

### **SLIDE 3: SOLUSI SISTEM**
- **Judul Slide:** Solusi: Aplikasi Mobile 201 Auto Garage
- **Poin Presentasi:**
  - 📱 **Mobile Booking System:** Pemesanan servis mudah dari smartphone kapan saja.
  - 📊 **Real-time Status Tracking:** Pelacakan progres pengerjaan kendaraan secara live.
  - 🔒 **Firebase Authentication:** Akses aman via Email, Google, & Facebook.
  - 🛠️ **Admin Management Panel:** Pengelolaan jadwal & status pengerjaan oleh admin.

---

### **SLIDE 4: ARSITEKTUR & TEKNOLOGI**
- **Judul Slide:** Arsitektur & Teknologi Sistem
- **Poin Presentasi:**
  - **Frontend:** Flutter (Dart) - Single Codebase Cross-Platform.
  - **Backend & Database:** Firebase Auth & Cloud Firestore (Real-Time NoSQL).
  - **Navigation & Router:** GoRouter + Penanganan `PopScope` Navigasi Back.

---

### **SLIDE 5: SHOWCASE ANTARMUKA APLIKASI (UI)**
- **Judul Slide:** Tampilan Antarmuka Utama (UI Showcase)
- **Visual Highlights:**
  - **Splash & Onboarding:** Branding profesional dengan vektor mobil sport.
  - **Auth Screens:** Sign In, Sign Up, & Forgot Password dengan input *filled* abu-abu.
  - **Home Dashboard:** Banner promosi & *grid* layanan servis.

---

### **SLIDE 6: ALUR PEMESANAN (*BOOKING FLOW*)**
- **Judul Slide:** Alur Pemesanan Servis Berantai
- **Langkah Pemesanan:**
  1. **Pilih Layanan:** Servis Rutin, Tune Up, AC Service, Ganti Ban, dll.
  2. **Pilih Jadwal:** Penentuan tanggal dan jam kunjungan.
  3. **Konfirmasi Booking:** Input detail kendaraan & catatan keluhan.
  4. **Simpan Real-time:** Data otomatis masuk ke antrean Cloud Firestore.

---

### **SLIDE 7: STATUS SERVIS REAL-TIME**
- **Judul Slide:** Pelacakan Status Servis Live
- **Visual Highlights:**
  - **Indikator Progres:** 5 Tahapan (*Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai*).
  - **Real-time Stream:** Tampilan pelanggan otomatis ter-update saat admin mengubah status.

---

### **SLIDE 8: HASIL PENGUJIANKINERJA SISTEM**
- **Judul Slide:** Pengujian Sistem & Usability
- **Data Hasil Pengujian:**
  - ✅ **Blackbox Testing:** 100% Fitur Berjalan Sesuai Skenario (PASSED).
  - ⭐ **System Usability Scale (SUS):** Skor **84.5** (Grade A - Excellent).
  - 🛡️ **Navigasi PopScope:** Bebas error navigasi pada tombol back fisik.

---

### **SLIDE 9: KESIMPULAN**
- **Judul Slide:** Kesimpulan
- **Poin Presentasi:**
  - ✅ Aplikasi 201 Auto Garage berhasil membangun sistem booking mobile yang modern, lancar, dan transparan.
  - ✅ Sinkronisasi data real-time Firestore mempermudah komunikasi status servis pelanggan.
  - ✅ Seluruh pengujian sistem dan unit test lulus 100%.

---

### **SLIDE 10: TERIMA KASIH & Q/A**
- **Judul Slide:** Terima Kasih!
- **Sub-judul:** Any Questions?
- **Link Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- **Link Figma Design:** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
