# 🚗 201 Auto Garage - Mobile Servis Kendaraan
> **Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase**

[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore_%26_Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![Build Status](https://img.shields.io/badge/Tests-100%25_Passed-10B981)](#-unit-testing)

---

## 📑 **DOKUMEN LAPORAN (MODUL 5):**

- 📖 **[Laporan Lengkap Modul 5 (Markdown)](DOCS/LAPORAN_MODUL_5.md)**
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

## 💻 **Kodingan Utama (*Source Code Snippets*):**

### 1. **Live Stream Status Servis Firestore (`booking_service.dart`):**
```dart
Stream<List<BookingModel>> streamActiveBookings() {
  final uid = _auth.currentUser?.uid;
  if (uid == null) return Stream.value([]);

  return _db.collection('bookings')
      .where('userId', isEqualTo: uid)
      .where('status', whereIn: ['Menunggu', 'Proses Pengecekan', 'Sedang Dikerjakan', 'Quality Check'])
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
          .toList());
}
```

### 2. **Navigasi Tombol Back Safe Guard (`PopScope`):**
```dart
PopScope(
  canPop: false,
  onPopInvokedWithResult: (bool didPop, Object? result) {
    if (!didPop) _handleBack(context);
  },
  child: Scaffold(...),
)
```

---

## ⚡ **Cara Menjalankan Aplikasi:**

### 1. Jalankan Aplikasi Flutter:
```bash
flutter pub get
flutter run
```

Untuk menjalankan API prediksi Python dari **perangkat Android fisik**, jalankan
server di komputer dengan `python_backend/app.py`, pastikan perangkat dan
komputer berada di jaringan yang sama, lalu gunakan alamat IPv4 komputer:

```powershell
flutter run -d <device-id> --dart-define=ML_API_URL=http://<IP-KOMPUTER>:5000/predict
```

Contoh, ganti `192.168.1.10` dengan alamat IPv4 komputer yang terlihat di
`ipconfig`. Izinkan koneksi masuk ke port `5000` di Windows Firewall bila
diperlukan. Untuk emulator Android, alamat default `10.0.2.2` tetap digunakan.
HTTP tanpa enkripsi hanya diizinkan untuk build debug Android; gunakan HTTPS
untuk deployment.

### 2. Jalankan Unit Test:
```bash
flutter test
```

### 3. Uji Aturan Firestore secara Lokal:
```bash
npm install --prefix firestore_test
npx firebase-tools emulators:exec --only firestore --project demo-auto-garage --config firebase.json "npm --prefix firestore_test test"
```

Pengujian menggunakan project demo dan emulator lokal; perintah ini tidak
mengubah data Firebase produksi. Emulator Firestore memerlukan Java.

---

**© 2026 201 Auto Garage - Mobile Servis Kendaraan**
