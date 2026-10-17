# 🚗 201 Auto Garage - Mobile Servis & AI Estimator
> **Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase dengan Integrasi Random Forest Regression**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore_%26_Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![Python](https://img.shields.io/badge/Python-scikit--learn-3776AB?logo=python)](https://scikit-learn.org)
[![Build Status](https://img.shields.io/badge/Tests-100%25_Passed-10B981)](#-unit-testing)

---

## 📑 **DOKUMEN LAPORAN & PRESENTASI (MODUL 5):**

- 📖 **[Laporan Lengkap Modul 5 (Markdown)](DOCS/LAPORAN_MODUL_5.md)**
- 📄 **[Download Laporan PDF](LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf)**
- 📊 **[Download Slide Presentasi PPTX](PRESENTASI_201_AUTO_GARAGE.pptx)**
- 🎨 **[Desain UI/UX Figma](https://www.figma.com/file/201-AutoGarage-UI-Design)**

---

## 🌟 **Fitur Utama Aplikasi:**

1. 📱 **Mobile Booking Servis Berantai:**
   - Pemesanan jadwal servis mudah (Pilih Layanan → Tanggal → Jam → Konfirmasi Prediksi AI).
2. 🤖 **Machine Learning Cost & Duration Estimator:**
   - Algoritma **Random Forest Regression** memprediksi estimasi biaya ($R^2 = 0.938$, $\text{MAPE} = 4.82\%$) dan durasi pengerjaan.
3. 📊 **Real-time Status Tracking:**
   - Pelacakan pengerjaan mobil live berbasis Cloud Firestore (*Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai*).
4. 🔒 **Multi-Platform Authentication:**
   - Sign In & Sign Up via Email/Password, Google Sign-In, dan Facebook.
5. 🛡️ **Seamless Back Navigation (`PopScope`):**
   - Bebas error navigasi pada seluruh 17+ layar.

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
  │ Firebase Auth & Firestore │                 │ Python ML REST API Server │
  │ - Booking Realtime        │                 │ (Flask / FastAPI)         │
  │ - Status & History        │                 │ - Random Forest Regressor │
  └───────────────────────────┘                 └───────────────────────────┘
```

---

## ⚡ **Cara Menjalankan Aplikasi & Server ML:**

### 1. Jalankan Aplikasi Flutter:
```bash
flutter pub get
flutter run
```

### 2. Jalankan Server Python ML REST API:
```bash
cd python_backend
pip install -r requirements.txt
python train_model.py
python app.py
```

### 3. Jalankan Unit Test:
```bash
flutter test test/random_forest_service_test.dart
```

---

**© 2026 201 Auto Garage - Mobile Servis & Machine Learning Estimator**
