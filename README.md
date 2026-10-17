# 🚗 201 Auto Garage - Mobile Servis Kendaraan
> **Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore_%26_Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![Build Status](https://img.shields.io/badge/Tests-100%25_Passed-10B981)](#-unit-testing)

---

## 📑 **DOKUMEN LAPORAN & PRESENTASI (MODUL 5):**

- 📖 **[Laporan Lengkap Modul 5 (Markdown)](DOCS/LAPORAN_MODUL_5.md)**
- 📄 **[Download Laporan PDF](LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf)**
- 📊 **[Download Slide Presentasi PPTX](PRESENTASI_201_AUTO_GARAGE_APP_DEV.pptx)**
- 🎨 **[Desain UI/UX Figma](https://www.figma.com/file/201-AutoGarage-UI-Design)**

---

## 🌟 **Fitur Utama Aplikasi:**

1. 📱 **Mobile Booking Servis Berantai:**
   - Pemesanan jadwal servis mudah (Pilih Layanan → Tanggal → Jam → Konfirmasi Booking).
2. 📊 **Real-time Status Tracking:**
   - Pelacakan pengerjaan mobil live berbasis Cloud Firestore (*Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai*).
3. 🔒 **Multi-Platform Authentication:**
   - Sign In & Sign Up via Email/Password, Google Sign-In, dan Facebook.
4. 🛡️ **Seamless Back Navigation (`PopScope`):**
   - Bebas error navigasi pada seluruh 17+ layar.
5. 🛠️ **Dashboard Admin Management:**
   - Pengelolaan antrean booking dan pengubahan status servis real-time.

---

## 🏗️ **Arsitektur Sistem:**

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

---

## ⚡ **Cara Menjalankan Aplikasi:**

### 1. Jalankan Aplikasi Flutter:
```bash
flutter pub get
flutter run
```

### 2. Jalankan Unit Test:
```bash
flutter test test/random_forest_service_test.dart
```

---

**© 2026 201 Auto Garage - Mobile Servis Kendaraan**
