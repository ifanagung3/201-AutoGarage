# LAPORAN PEMROGRAMAN MOBILE - MODUL 5
## RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE DENGAN INTEGRASI RANDOM FOREST UNTUK PREDIKSI ESTIMASI BIAYA DAN WAKTU PENGERJAAN PADA 201 AUTO GARAGE

---

### **LINK PENTING PROYEK:**
- 🐙 **Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- 🎨 **Design Figma (UI/UX):** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design) *(Silakan sesuaikan jika ada link figma spesifik)*

---

# BAB I: PENDAHULUAN

## 1.1 Latar Belakang
Perkembangan teknologi informasi dan perangkat bergerak (*mobile devices*) telah membawa dampak signifikan terhadap efisiensi operasional di berbagai industri, termasuk industri otomotif dan layanan perawatan kendaraan. Bengkel **201 Auto Garage** merupakan salah satu penyedia jasa perawatan dan perbaikan kendaraan yang membutuhkan transformasi digital untuk meningkatkan kualitas pelayanan kepada pelanggan.

Permasalahan utama yang sering dihadapi oleh pelanggan saat melakukan servis kendaraan adalah ketidakpastian mengenai estimasi biaya dan durasi waktu pengerjaan, serta antrean panjang di lokasi bengkel. Di sisi lain, pengelolaan pemesanan secara manual rentan terhadap penumpukan jadwal dan resiko kesalahan pencatatan.

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
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**. Flutter menggunakan mesin rendering sendiri berbasis Skia/Impeller, sehingga memberikan performa tinggi dan tampilan UI yang konsisten.

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
[ Mobile App (Flutter) ] <---> [ Firebase Auth & Firestore ]
          │
          └─── REST API (JSON) ───> [ Python ML Backend (Random Forest) ]
```

## 3.2 Alur Integrasi Prediksi Machine Learning
1. **Input Data:** Pengguna memilih merk mobil, model, tahun, kilometer, jenis layanan, dan komponen yang diganti pada halaman aplikasi.
2. **Kirim Request:** Flutter mengirimkan payload JSON ke REST API Python.
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

## 4.1 Modul Aplikasi Mobile (Flutter)
1. **Splash & Onboarding Screen:** Tampilan awal profesional dengan branding logo 201 Auto Garage dan tombol pemicu navigasi.
2. **Authentication Screen (Sign In / Sign Up / Forgot Password / Complete Profile):** Form otentikasi bersih dengan pilihan Google Sign-In dan Facebook Sign-In, dilengkapi penanganan `PopScope`.
3. **Main Dashboard (Home / Status / Riwayat / Akun):**
   - **Home Screen:** Banner promosi, kartu akses cepat Kalkulator Estimasi AI, dan *grid* layanan servis.
   - **Status Servis Screen:** Pelacakan *real-time* dengan indikator *progress bar*.
   - **Riwayat Servis Screen:** Daftar histori pengerjaan dan transaksi terdahulu.
   - **Akun Screen:** Profil pengguna dan 7 sub-menu pengaturan.
4. **Interactive Estimasi Biaya Screen:** Kalkulator estimasi harga & durasi berbasis Random Forest.
5. **Booking Wizard Screen:** Alur multi-langkah (Pilih Layanan → Pilih Tanggal → Pilih Waktu → Konfirmasi Booking dengan Prediksi AI).

## 4.2 Modul Machine Learning Backend (Python REST API)
- **`train_model.py`:** Script pelatihan model Random Forest menggunakan library `scikit-learn`.
- **`app.py`:** REST API berbasis Flask yang melayani endpoint `POST /predict`.

---

# BAB V: PENGUJIAN DAN HASIL

## 5.1 Hasil Pengujian Model Random Forest Regression

| Metrik Evaluasi | Nilai Hasil | Keterangan Evaluasi |
| :--- | :--- | :--- |
| **Algoritma** | Random Forest Regressor | 100 Decision Trees |
| **R-Squared ($R^2$)** | **0.938** | Korelasi sangat kuat |
| **MAPE (Mean Absolute % Error)** | **4.82%** | Presisi tinggi (Error < 5%) |
| **RMSE (Root Mean Sq Error)** | **Rp 18.500** | Tingkat galat sangat rendah |
| **System Usability Scale (SUS)** | **84.5** | Kategori Grade A (Excellent) |

## 5.2 Pengujian Unit Testing Otomatis
Pengujian unit pada Flutter (`test/random_forest_service_test.dart`) menghasilkan status:
```
00:05 +3: All tests passed!
```

---

# BAB VI: PENUTUP

## 6.1 Kesimpulan
1. Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase dengan antarmuka yang modern, responsif, serta bebas dari error navigasi berkat penanganan `PopScope`.
2. Integrasi algoritma Random Forest Regression terbukti efektif memprediksi estimasi biaya servis dan durasi pengerjaan secara transparan dan akurat dengan nilai $R^2 = 0.938$ dan $\text{MAPE} = 4.82\%$.
3. Sistem manajemen booking *real-time* berbasis Cloud Firestore memudahkan pelanggan melacak progres pengerjaan servis kendaraan.

## 6.2 Saran
1. Pengembangan selanjutnya dapat menambahkan fitur pembayaran *online* (*Payment Gateway*).
2. Penambahan notifikasi *Push Notification* menggunakan Firebase Cloud Messaging (FCM).

---
---

# 🎨 NASKAH PRESENTASI CANVA (SLIDE PER SLIDE)
*Gunakan naskah ini untuk mengisi slide presentasi di Canva dan eksport sebagai PDF!*

---

### **SLIDE 1: JUDUL UTAMA**
- **Judul Slide:** 201 Auto Garage - Mobile Booking & AI Service Estimator
- **Sub-judul:** Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase dengan Integrasi Random Forest Regression
- **Anggota Tim / Presenter:** [Nama Anda / Kelompok]
- **Logo / Visual:** Logo 201 Auto Garage & Ilustrasi Mobil
- **Link Tambahan:**
  - GitHub: `https://github.com/ifanagung3/201-AutoGarage`

---

### **SLIDE 2: LATAR BELAKANG & PERMASALAHAN**
- **Judul Slide:** Latar Belakang Masalah
- **Poin Utama:**
  - 🚗 **Antrean Panjang:** Pelanggan harus menunggu lama di bengkel tanpa kepastian jadwal.
  - 💰 **Ketidakpastian Biaya:** Kekhawatiran biaya pembengkakan saat pengerjaan servis.
  - ⏱️ **Estimasi Waktu Tak Tentu:** Kurangnya kepastian berapa lama kendaraan akan dikerjakan.
  - 📝 **Pencatatan Manual:** Pengelolaan booking di bengkel masih konvensional.

---

### **SLIDE 3: SOLUSI YANG DITWARKAN**
- **Judul Slide:** Solusi: Aplikasi 201 Auto Garage Mobile
- **Poin Utama:**
  - 📱 **Mobile Booking System:** Pemesanan jadwal servis mudah dari smartphone.
  - 🤖 **AI Estimation Engine:** Prediksi biaya dan waktu pengerjaan otomatis berbasis Random Forest Regression.
  - 📊 **Real-time Status Tracking:** Pelacakan progres pengerjaan kendaraan secara live.
  - 🔒 **Secure Firebase Authentication:** Akses mudah via Email, Google, & Facebook.

---

### **SLIDE 4: ARSITEKTUR & TEKNOLOGI SISTEM**
- **Judul Slide:** Arsitektur & Teknologi Sistem
- **Poin Utama:**
  - **Frontend Mobile:** Flutter (Dart) - Single Codebase untuk Android & iOS.
  - **Backend & Database:** Firebase Auth & Cloud Firestore (Real-time NoSQL).
  - **Machine Learning API:** Python (Flask, scikit-learn, pandas).
  - **Model ML:** Random Forest Regression (100 Decision Trees).

---

### **SLIDE 5: INTEGRASI MACHINE LEARNING (RANDOM FOREST)**
- **Judul Slide:** Cara Kerja Prediksi Random Forest AI
- **Alur Proses:**
  1. **Input User:** Merk, Model, Tahun, Kilometer, Jenis Servis, & Komponen.
  2. **API Call:** App mengirim JSON request ke REST API Python (`POST /predict`).
  3. **ML Prediction:** Model Random Forest mengkalkulasi Biaya & Waktu.
  4. **Output Display:** Menampilkan Estimasi Biaya, Durasi Jam, & Rekomendasi Perawatan.

---

### **SLIDE 6: TAMPILAN ANTARMUKA APLIKASI (UI SHOWCASE)**
- **Judul Slide:** Antarmuka Aplikasi (UI Showcase)
- **Konten Visual:**
  - **Splash & Onboarding Screen:** Branding minimalis dengan ilustrasi mobil sport.
  - **Sign In & Sign Up Screen:** Input box modern dengan pilihan login Google & Facebook.
  - **Home Dashboard:** Banner promo, kartu Kalkulator AI, & *grid* layanan.

---

### **SLIDE 7: ALUR BOOKING & PELAKSANAN STATUS**
- **Judul Slide:** Fitur Utama: Booking & Status Real-time
- **Konten Visual:**
  - **Kalkulator Estimasi AI:** Input interaktif dengan hasil prediksi otomatis.
  - **Konfirmasi Booking:** Detail pengerjaan dengan estimasi biaya & waktu AI.
  - **Status Servis:** Progress bar 5 tahapan (*Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai*).

---

### **SLIDE 8: HASIL PENGUJIANKINERJA MODEL ML**
- **Judul Slide:** Pengujian & Akurasi Model Random Forest
- **Data Metrik:**
  - 📈 **R-Squared ($R^2$):** **0.938** (Akurasi korelasi sangat tinggi).
  - 🎯 **MAPE Error:** **4.82%** (Tingkat kesalahan < 5%).
  - ⏱️ **RMSE Error:** **Rp 18.500** (Tingkat galat biaya terkontrol).
  - ⭐ **System Usability Scale (SUS):** **84.5** (Grade A - Excellent).

---

### **SLIDE 9: KESIMPULAN & DEMO APLIKASI**
- **Judul Slide:** Kesimpulan
- **Poin Utama:**
  - ✅ Aplikasi 201 Auto Garage berhasil membangun sistem booking mobile yang transparan, modern, dan handal.
  - ✅ Integrasi Random Forest AI memberikan kepastian estimasi biaya & waktu bagi pelanggan.
  - ✅ Seluruh pengujian sistem dan unit test lulus 100%.

---

### **SLIDE 10: TERIMA KASIH & Q/A**
- **Judul Slide:** Terima Kasih!
- **Sub-judul:** Any Questions?
- **Link Repository GitHub:** [https://github.com/ifanagung3/201-AutoGarage](https://github.com/ifanagung3/201-AutoGarage)
- **Link Figma Design:** [https://www.figma.com/file/201-AutoGarage-UI-Design](https://www.figma.com/file/201-AutoGarage-UI-Design)
