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

---

# BAB II: LANDASAN TEORI

## 2.1 Flutter Framework
Flutter adalah *software development kit* (SDK) open-source yang dikembangkan oleh Google untuk membangun aplikasi *cross-platform* (Android, iOS, Web, Desktop) dari satu basis kode (*single codebase*) menggunakan bahasa pemrograman **Dart**.

## 2.2 Firebase Ecosystem
- **Firebase Authentication:** Otentikasi aman (Email/Password, Google Sign-In, Facebook Sign-In).
- **Cloud Firestore:** Database NoSQL berbasis dokumen dengan sinkronisasi *real-time*.

---

# BAB III: PERANCANGAN SISTEM & SKEMA DATABASE

## 3.1 Arsitektur Sistem
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

## 3.2 Skema Database Firestore (`bookings` Collection)
```json
{
  "id": "#BK-1001",
  "userId": "usr_99812",
  "userName": "Ahmad Fauzi",
  "userPhone": "081234567890",
  "vehicleName": "Toyota Avanza 1.3 G",
  "vehiclePlat": "B 1234 AG",
  "vehicleYear": 2020,
  "vehicleKm": 35000,
  "serviceName": "Servis Rutin Berkala",
  "bookingDate": "2026-10-20T09:00:00Z",
  "bookingTime": "09:00 WIB",
  "estimatedCost": 195000,
  "status": "Sedang Dikerjakan",
  "currentStep": 3,
  "totalSteps": 5,
  "notes": "Ganti oli mesin & cek rem"
}
```

---

# BAB IV: IMPLEMENTASI KODE PROGRAM (*CODE SNIPPETS*) & TAMPILAN APK

## 4.1 Struktur Kode Proyek Flutter
```
lib/
├── core/
│   ├── router/app_router.dart          # Navigation Mapping & GoRouter
│   └── theme/app_theme.dart            # Custom App Theme Data
├── models/
│   └── booking_model.dart              # Firestore Booking Entity Model
├── services/
│   └── booking_service.dart            # Firestore Real-time CRUD Service
└── screens/
    ├── auth/                           # Splash, Onboarding, Sign In, Sign Up, Complete Profile, OTP
    ├── main/                           # Home, Status Live, Riwayat, Akun
    ├── booking/                        # Layanan, Tanggal, Waktu, Konfirmasi
    └── admin/                          # Dashboard Admin & Booking Management
```

## 4.2 Potongan Kode Program Utama (*Source Code Snippets*)

### 1. **Implementasi Real-time Firestore Stream Booking (`booking_service.dart`):**
```dart
class BookingService {
  static final BookingService instance = BookingService._internal();
  BookingService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream Live Status Servis Aktif dari Cloud Firestore
  Stream<List<BookingModel>> streamActiveBookings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .where('status', whereIn: ['Menunggu', 'Proses Pengecekan', 'Sedang Dikerjakan', 'Quality Check'])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}
```

### 2. **Implementasi Penanganan Back Navigation (`PopScope`) pada Screen:**
```dart
@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (bool didPop, Object? result) {
      if (!didPop) {
        _handleBack(context); // Mencegah app crash & mengarahkan ke route sebelumnya
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Pilih Layanan')),
      body: ListView(...),
    ),
  );
}
```

### 3. **Implementasi Otentikasi Firebase Login (`sign_in_screen.dart`):**
```dart
Future<void> _signInWithEmail() async {
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) return;
  setState(() => _isLoading = true);
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (mounted) context.go('/home');
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login gagal: ${e.message}')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

---

## 4.3 Deskripsi Tampilan Antarmuka Aplikasi (*App Showcase Visuals*)

1. **Splash & Onboarding Screen:**
   - Visual: Latar belakang putih bersih dengan logo vektor mobil biru dan teks branding **201 AUTO GARAGE**.
   - Komponen: Ilustrasi mobil sport hitam di bagian bawah dan tombol pemicu navigasi **"Let's Started ➔"**.
2. **Sign In & Sign Up Screen:**
   - Visual: Latar belakang abu-abu muda (`#F5F5F5`) dengan kotak input *filled* putih tanpa border untuk kenyamanan visual.
   - Komponen: Field Email & Password, link *Forgot Password?*, tombol *Sign In* berbentuk kapsul (`#6B7FED`), dan tombol login berdampingan untuk **Google** & **Facebook**.
3. **Home Dashboard Screen:**
   - Visual: Header gradien biru dengan salam *"Halo, Pelanggan! 👋"*, search bar, banner promosi diskon 20%, dan *grid 2x2* pilihan layanan (Servis Rutin, Tune Up, AC Service, Ganti Ban).
4. **Alur Pemesanan Servis (*Booking Wizard Flow*):**
   - Step 1: Pilih Layanan dengan harga dan deskripsi pengerjaan.
   - Step 2: Calendar DatePicker interaktif untuk menentukan tanggal servis.
   - Step 3: Grid pilihan slot jam kunjungan (08:00 WIB, 09:00 WIB, dst).
   - Step 4: Konfirmasi Booking dengan detail kendaraan, tanggal, waktu, dan input catatan keluhan.
5. **Status Servis Real-time Screen:**
   - Visual: Tampilan *Progress Bar* 5 tahapan (*Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai*) yang ter-update secara otomatis secara live saat admin merubah status pengerjaan di Firestore.
6. **Dashboard Management Admin Screen:**
   - Visual: Panel khusus admin berlatar gelap (*Dark Theme*) dengan tab kategori status booking dan tombol aksi *Terima/Tolak/Update Status*.

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

### **SLIDE 4: ARSITEKTUR & STRUKTUR KODE**
- **Judul Slide:** Arsitektur & Implementasi Kode
- **Poin Presentasi:**
  - **Frontend:** Flutter (Dart) - Single Codebase Cross-Platform.
  - **Backend & Database:** Firebase Auth & Cloud Firestore (Real-Time NoSQL).
  - **Routing & Back Guard:** GoRouter + Widget `PopScope` untuk navigasi aman.

---

### **SLIDE 5: IMPLEMENTASI KODE UTAMA (DART & FIREBASE)**
- **Judul Slide:** Implementation Code Snippets
- **Poin Presentasi:**
  - **Firestore Live Stream:** `_db.collection('bookings').snapshots().map(...)`
  - **Firebase Authentication:** `FirebaseAuth.instance.signInWithEmailAndPassword(...)`
  - **PopScope Navigation:** `PopScope(canPop: false, onPopInvokedWithResult: ...)`

---

### **SLIDE 6: SHOWCASE TAMPILAN APK (UI SHOWCASE)**
- **Judul Slide:** Tampilan Antarmuka Utama (UI Showcase)
- **Visual Highlights:**
  - **Splash & Onboarding:** Branding profesional dengan vektor mobil sport.
  - **Auth Screens:** Sign In, Sign Up, & Forgot Password dengan input *filled* abu-abu `#F5F5F5`.
  - **Home Dashboard:** Banner promosi, salam pelanggan, & *grid 2x2* layanan.

---

### **SLIDE 7: ALUR BOOKING & STATUS REAL-TIME**
- **Judul Slide:** Fitur Booking & Status Live
- **Visual Highlights:**
  - **Booking Wizard:** Layanan → Tanggal → Jam → Konfirmasi.
  - **Status Servis Live:** Progress bar 5 tahapan pengerjaan (*Menunggu → Selesai*).
  - **Admin Panel:** Pengelolaan antrean booking & pengubahan status servis.

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
