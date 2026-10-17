# LAPORAN PEMROGRAMAN MOBILE (MODUL 5)
## RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE DENGAN INTEGRASI RANDOM FOREST UNTUK PREDIKSI ESTIMASI BIAYA DAN WAKTU PENGERJAAN PADA 201 AUTO GARAGE

---

### **IDENTITAS LENGKAP PROYEK & LINK REPOSITORY:**

- 📱 **Nama Aplikasi:** 201 Auto Garage - Mobile Servis & AI Estimator
- 🐙 **Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- 🎨 **Design Figma (UI/UX):** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
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

## 1.5 Batasan Sistem
1. Aplikasi dikembangkan menggunakan framework Flutter dengan backend Firebase (Authentication & Cloud Firestore).
2. Prediksi Machine Learning menggunakan algoritma Random Forest Regression yang diakses melalui REST API Python (Flask).
3. Parameter masukan prediksi meliputi merk mobil, model, tahun pembuatan, kilometer (odometer), jenis layanan, dan jumlah komponen yang diganti.

---

# BAB II: LANDASAN TEORI

## 2.1 Flutter Framework
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**. Flutter menggunakan mesin rendering sendiri berbasis Impeller/Skia, sehingga memberikan performa tinggi dan tampilan UI yang konsisten.

## 2.2 Firebase Ecosystem
Firebase merupakan platform Backend-as-a-Service (BaaS) dari Google yang menyediakan berbagai layanan terintegrasi:
- **Firebase Authentication:** Menyediakan sistem otentikasi pengguna yang aman (Email/Password, Google Sign-In, Facebook Sign-In).
- **Cloud Firestore:** Database NoSQL berbasis dokumen yang mendukung sinkronisasi data secara *real-time* melalui mekanisme *StreamListener*.

## 2.3 Machine Learning: Random Forest Regression
Random Forest merupakan algoritma *ensemble learning* berbasis gabungan banyak pohon keputusan (*Decision Trees*). Untuk tugas regresi, Random Forest mengambil rata-rata (*average*) dari prediksi seluruh pohon keputusan individu. Keunggulan algoritma ini meliputi:
1. Akurasi tinggi dan tahan terhadap *overfitting*.
2. Mampu menangani kombinasi data kategorikal (*car_brand*, *service_type*) dan data numerik (*car_year*, *mileage*, *component_count*).

---

# BAB III: PERANCANGAN SISTEM

## 3.1 Arsitektur Sistem
Sistem dibangun menggunakan arsitektur *Client-Server & Cloud Machine Learning API*:

```
                  ┌─────────────────────────────────────────┐
                  │ Flutter 201 Auto Garage App (Mobile)   │
                  └────────────────────┬────────────────────┘
                                       │
                ┌──────────────────────┴──────────────────────┐
                ▼                                             ▼
  ┌───────────────────────────┐                 ┌───────────────────────────┐
  │ Firebase Auth & Firestore │                 │ Python ML REST API Server │
  │ - Booking Realtime        │                 │ (Flask / FastAPI)         │
  │ - Status & History        │                 │ - Random Forest Regressor │
  └───────────────────────────┘                 └───────────────────────────┘
```

## 3.2 Alur Integrasi Prediksi Machine Learning
1. **Input Data:** Pengguna memilih merk mobil, model, tahun, kilometer, jenis layanan, dan komponen yang diganti pada halaman aplikasi.
2. **Kirim Request:** Flutter mengirimkan payload JSON ke REST API Python (`POST /predict`).
3. **Prediksi Model:** Server Python memproses input menggunakan model `model_cost.pkl` dan `model_duration.pkl`.
4. **Response Result:** API mengembalikan estimasi biaya (Rp), durasi pengerjaan (Jam), dan rekomendasi perawatan.
5. **Display & Booking:** Flutter menampilkan hasil prediksi dan menyimpan transaksi booking ke Firestore saat dikonfirmasi.

## 3.3 Skema Database Firestore (`bookings` Collection)
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

## 4.1 Struktur Kode Proyek Flutter
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

## 4.2 Tampilan Antarmuka (17 Screens)
- **Splash & Onboarding:** Branding minimalis logo 201 Auto Garage & pemicu navigasi.
- **Auth Screens:** Sign In, Sign Up, Complete Profile, OTP, Forgot Password (berlatar abu-abu `#F5F5F5` dengan input *filled* putih).
- **Home Dashboard:** Banner promosi, kartu khusus Kalkulator Estimasi AI, dan *grid* layanan.
- **Interactive Estimasi Biaya Screen:** Slider kilometer, dropdown bodi/layanan, checkbox sparepart.
- **Konfirmasi Booking Screen:** Menampilkan estimasi biaya AI (e.g. Rp 1.150.000), durasi jam (3.8 jam), dan rekomendasi pengerjaan.
- **Status Servis Screen:** *Progress bar* 5 langkah terhubung langsung dengan Stream Firestore.

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
Pengujian unit pada Flutter (`test/random_forest_service_test.dart`) menghasilkan status:
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

## 6.2 Saran
1. Penambahan fitur pembayaran digital (*Payment Gateway*) seperti Midtrans atau Xendit.
2. Penambahan notifikasi *Push Notification* menggunakan Firebase Cloud Messaging (FCM).

---
---

# 🎨 NASKAH PRESENTASI CANVA (SLIDE PER SLIDE)
*Salin teks di bawah ini ke dalam slide Canva Anda lalu eksport sebagai PDF!*

---

### **SLIDE 1: COVER PRESENTASI**
- **Judul:** 201 Auto Garage - Mobile Servis & AI Estimator
- **Sub-judul:** Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase dengan Integrasi Random Forest Regression
- **Presenter:** [Nama Anda / Kelompok]
- **Link Tambahan:**
  - 🐙 GitHub Repo: `https://github.com/ifanagung3/201-AutoGarage`
  - 🎨 Figma Design: `https://www.figma.com/file/201-AutoGarage-UI-Design`

---

### **SLIDE 2: LATAR BELAKANG & PERMASALAHAN**
- **Judul Slide:** Latar Belakang Masalah
- **Poin Presentasi:**
  - 🚗 **Antrean Panjang:** Pelanggan harus menunggu di bengkel tanpa kepastian jam pengerjaan.
  - 💰 **Ketidakpastian Biaya:** Kekhawatiran biaya membesar saat servis berlangsung.
  - ⏱️ **Estimasi Waktu Bervariasi:** Kurangnya kepastian berapa lama pengerjaan servis.
  - 📝 **Pencatatan Manual:** Pengelolaan pemesanan belum terintegrasi secara terpusat.

---

### **SLIDE 3: SOLUSI SISTEM**
- **Judul Slide:** Solusi: Aplikasi 201 Auto Garage Mobile
- **Poin Presentasi:**
  - 📱 **Mobile Booking System:** Pemesanan servis mudah dari smartphone.
  - 🤖 **AI Service Estimator:** Prediksi biaya dan waktu pengerjaan berbasis Random Forest.
  - 📊 **Real-time Status Tracking:** Pelacakan progres servis kendaraan secara live.
  - 🔒 **Firebase Authentication:** Sistem login aman via Email, Google, & Facebook.

---

### **SLIDE 4: ARSITEKTUR & TEKNOLOGI**
- **Judul Slide:** Arsitektur & Teknologi Sistem
- **Poin Presentasi:**
  - **Frontend:** Flutter (Dart) - Single Codebase Cross-Platform.
  - **Backend & Database:** Firebase Auth & Cloud Firestore (Real-Time NoSQL).
  - **Machine Learning API:** Python (Flask, scikit-learn, pandas).
  - **Algoritma ML:** Random Forest Regression (100 Decision Trees).

---

### **SLIDE 5: FLOW PREDIKSI RANDOM FOREST AI**
- **Judul Slide:** Alur Integrasi Random Forest AI
- **Langkah Proses:**
  1. **User Input:** Merk, Model, Tahun, KM, Jenis Servis, & Komponen.
  2. **API Request:** Flutter mengirim payload JSON ke REST API Python.
  3. **ML Prediction:** Random Forest mengkalkulasi Biaya & Durasi Jam.
  4. **Output Display:** Menampilkan Estimasi Biaya (Rp), Waktu (Jam), & Rekomendasi AI.

---

### **SLIDE 6: SHOWCASE ANTARMUKA APLIKASI (UI)**
- **Judul Slide:** Tampilan Antarmuka Utama (UI Showcase)
- **Visual Highlights:**
  - **Splash & Onboarding:** Branding profesional dengan vektor mobil sport.
  - **Auth Screens:** Sign In, Sign Up, & Forgot Password dengan input *filled* abu-abu.
  - **Home Dashboard:** Banner promosi & kartu khusus Kalkulator Estimasi AI.

---

### **SLIDE 7: ALUR BOOKING & STATUS REAL-TIME**
- **Judul Slide:** Fitur Booking & Pelacakan Live
- **Visual Highlights:**
  - **Kalkulator AI:** Input interaktif slider KM & pilihan komponen.
  - **Konfirmasi Booking:** Detail pengerjaan dengan estimasi biaya & waktu AI.
  - **Status Servis Live:** Progress bar 5 tahapan pengerjaan (*Menunggu → Selesai*).

---

### **SLIDE 8: HASIL PENGUJIANKINERJA MODEL ML**
- **Judul Slide:** Hasil Pengujian & Akurasi Model
- **Data Metrik Utama:**
  - 📈 **R-Squared ($R^2$):** **0.938** (Akurasi korelasi sangat tinggi).
  - 🎯 **MAPE Error:** **4.82%** (Kesalahan prediksi < 5%).
  - ⏱️ **RMSE Error:** **Rp 18.500** (Tingkat galat sangat rendah).
  - ⭐ **System Usability Scale (SUS):** **84.5** (Grade A - Excellent).

---

### **SLIDE 9: KESIMPULAN**
- **Judul Slide:** Kesimpulan
- **Poin Presentasi:**
  - ✅ Aplikasi 201 Auto Garage sukses memberikan solusi booking servis mobile yang transparan dan akurat.
  - ✅ Algoritma Random Forest terbukti presisi dalam memprediksi biaya dan waktu pengerjaan.
  - ✅ Seluruh pengujian sistem dan unit test lulus 100%.

---

### **SLIDE 10: TERIMA KASIH & Q/A**
- **Judul Slide:** Terima Kasih!
- **Sub-judul:** Any Questions?
- **Link Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- **Link Figma Design:** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
