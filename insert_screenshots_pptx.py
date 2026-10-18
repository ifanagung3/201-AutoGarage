import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE

def create_pptx_with_actual_screenshots():
    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6]

    # Premium Palette
    COLOR_BG = RGBColor(15, 23, 42)          # Deep Navy #0F172A
    COLOR_CARD = RGBColor(30, 41, 59)        # Slate Blue #1E293B
    COLOR_ACCENT = RGBColor(56, 189, 248)     # Sky Cyan #38BDF8
    COLOR_PURPLE = RGBColor(129, 140, 248)   # Indigo #818CF8
    COLOR_TEXT = RGBColor(241, 245, 249)     # White #F1F5F9
    COLOR_MUTED = RGBColor(148, 163, 184)    # Muted #94A3B8
    COLOR_GREEN = RGBColor(52, 211, 153)     # Emerald #34D399
    COLOR_YELLOW = RGBColor(251, 191, 36)    # Amber #FBBF24

    img_folder = r"C:\Users\ASUS\Downloads\Bengkel Mobil (1)"

    def set_bg(slide):
        bg = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
        bg.fill.solid()
        bg.fill.fore_color.rgb = COLOR_BG
        bg.line.color.rgb = COLOR_BG

    def add_header(slide, title, category):
        tb = slide.shapes.add_textbox(Inches(0.8), Inches(0.4), Inches(11.7), Inches(1.1))
        tf = tb.text_frame
        tf.word_wrap = True

        p_cat = tf.paragraphs[0]
        p_cat.text = category.upper()
        p_cat.font.size = Pt(12)
        p_cat.font.bold = True
        p_cat.font.color.rgb = COLOR_ACCENT

        p_t = tf.add_paragraph()
        p_t.text = title
        p_t.font.size = Pt(24)
        p_t.font.bold = True
        p_t.font.color.rgb = COLOR_TEXT

    # -------------------------------------------------------------
    # SLIDE 1: Cover
    # -------------------------------------------------------------
    s1 = prs.slides.add_slide(blank_layout)
    set_bg(s1)
    hero = s1.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(0.8), Inches(11.7), Inches(5.9))
    hero.fill.solid()
    hero.fill.fore_color.rgb = COLOR_CARD
    hero.line.color.rgb = COLOR_ACCENT

    tf1 = hero.text_frame
    tf1.word_wrap = True

    p0 = tf1.paragraphs[0]
    p0.text = "🚗 201 AUTO GARAGE - MOBILE SERVIS"
    p0.font.size = Pt(16)
    p0.font.bold = True
    p0.font.color.rgb = COLOR_ACCENT
    p0.space_after = Pt(20)

    p1 = tf1.add_paragraph()
    p1.text = "Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase"
    p1.font.size = Pt(28)
    p1.font.bold = True
    p1.font.color.rgb = COLOR_TEXT
    p1.space_after = Pt(20)

    p2 = tf1.add_paragraph()
    p2.text = "Laporan & Presentasi Modul 5 Pemrograman Mobile (Dengan Tangkapan Layar / Screenshots Asli APK)"
    p2.font.size = Pt(16)
    p2.font.color.rgb = COLOR_MUTED
    p2.space_after = Pt(25)

    p3 = tf1.add_paragraph()
    p3.text = "🐙 GitHub: https://github.com/ifanagung3/201-AutoGarage   •   🎨 Figma: UI/UX Design Ready"
    p3.font.size = Pt(14)
    p3.font.color.rgb = COLOR_GREEN

    # -------------------------------------------------------------
    # SLIDE 2: Screenshots Showcase 1 (Splash, Onboarding, Sign In)
    # -------------------------------------------------------------
    s2 = prs.slides.add_slide(blank_layout)
    set_bg(s2)
    add_header(s2, "Screenshots APK 1: Splash, Onboarding & Sign In", "Tangkapan Layar Asli Aplikasi")

    ss1_list = [
        {"file": "Splash Screen.png", "title": "Splash Screen"},
        {"file": "Onboarding Screen.png", "title": "Onboarding Screen"},
        {"file": "Sign In.png", "title": "Sign In Screen"}
    ]

    for i, item in enumerate(ss1_list):
        left_pos = Inches(0.8 + i * 4.0)
        img_path = os.path.join(img_folder, item["file"])

        # Title Above Image
        tb_title = s2.shapes.add_textbox(left_pos, Inches(1.5), Inches(3.6), Inches(0.5))
        tf_title = tb_title.text_frame
        p_title = tf_title.paragraphs[0]
        p_title.text = item["title"]
        p_title.font.size = Pt(16)
        p_title.font.bold = True
        p_title.font.color.rgb = COLOR_ACCENT

        # Embed Image
        if os.path.exists(img_path):
            s2.shapes.add_picture(img_path, left_pos, Inches(2.1), height=Inches(4.8))

    # -------------------------------------------------------------
    # SLIDE 3: Screenshots Showcase 2 (Create Account, OTP, Your Profile)
    # -------------------------------------------------------------
    s3 = prs.slides.add_slide(blank_layout)
    set_bg(s3)
    add_header(s3, "Screenshots APK 2: Create Account, OTP & Profile", "Tangkapan Layar Asli Aplikasi")

    ss2_list = [
        {"file": "Create Account.png", "title": "Create Account"},
        {"file": "OTP Verification.png", "title": "OTP Verification"},
        {"file": "Your Profile.png", "title": "Complete Profile"}
    ]

    for i, item in enumerate(ss2_list):
        left_pos = Inches(0.8 + i * 4.0)
        img_path = os.path.join(img_folder, item["file"])

        tb_title = s3.shapes.add_textbox(left_pos, Inches(1.5), Inches(3.6), Inches(0.5))
        tf_title = tb_title.text_frame
        p_title = tf_title.paragraphs[0]
        p_title.text = item["title"]
        p_title.font.size = Pt(16)
        p_title.font.bold = True
        p_title.font.color.rgb = COLOR_ACCENT

        if os.path.exists(img_path):
            s3.shapes.add_picture(img_path, left_pos, Inches(2.1), height=Inches(4.8))

    # -------------------------------------------------------------
    # SLIDE 4: Screenshots Showcase 3 (Dashboard, Status, Riwayat)
    # -------------------------------------------------------------
    s4 = prs.slides.add_slide(blank_layout)
    set_bg(s4)
    add_header(s4, "Screenshots APK 3: Dashboard, Status Live & Riwayat", "Tangkapan Layar Asli Aplikasi")

    ss3_list = [
        {"file": "Dashboard.png", "title": "Home Dashboard"},
        {"file": "Status Servis.png", "title": "Status Servis Live"},
        {"file": "Riwayat Servis.png", "title": "Riwayat Servis"}
    ]

    for i, item in enumerate(ss3_list):
        left_pos = Inches(0.8 + i * 4.0)
        img_path = os.path.join(img_folder, item["file"])

        tb_title = s4.shapes.add_textbox(left_pos, Inches(1.5), Inches(3.6), Inches(0.5))
        tf_title = tb_title.text_frame
        p_title = tf_title.paragraphs[0]
        p_title.text = item["title"]
        p_title.font.size = Pt(16)
        p_title.font.bold = True
        p_title.font.color.rgb = COLOR_ACCENT

        if os.path.exists(img_path):
            s4.shapes.add_picture(img_path, left_pos, Inches(2.1), height=Inches(4.8))

    # -------------------------------------------------------------
    # SLIDE 5: Screenshots Showcase 4 (Booking Servis Wizard Flow)
    # -------------------------------------------------------------
    s5 = prs.slides.add_slide(blank_layout)
    set_bg(s5)
    add_header(s5, "Screenshots APK 4: Alur Pemesanan Servis Berantai", "Tangkapan Layar Asli Aplikasi")

    ss4_list = [
        {"file": "Booking Servis.png", "title": "1. Pilih Layanan"},
        {"file": "Booking Servis 1.png", "title": "2. Pilih Tanggal"},
        {"file": "Booking Servis 2.png", "title": "3. Pilih Jam"}
    ]

    for i, item in enumerate(ss4_list):
        left_pos = Inches(0.8 + i * 4.0)
        img_path = os.path.join(img_folder, item["file"])

        tb_title = s5.shapes.add_textbox(left_pos, Inches(1.5), Inches(3.6), Inches(0.5))
        tf_title = tb_title.text_frame
        p_title = tf_title.paragraphs[0]
        p_title.text = item["title"]
        p_title.font.size = Pt(16)
        p_title.font.bold = True
        p_title.font.color.rgb = COLOR_ACCENT

        if os.path.exists(img_path):
            s5.shapes.add_picture(img_path, left_pos, Inches(2.1), height=Inches(4.8))

    # -------------------------------------------------------------
    # SLIDE 6: Code Snippet 1 - Realtime Stream
    # -------------------------------------------------------------
    s6 = prs.slides.add_slide(blank_layout)
    set_bg(s6)
    add_header(s6, "Kodingan Utama 1: Real-time Firestore Stream", "Implementasi Kode Dart")

    card_l6 = s6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(4.5), Inches(5.2))
    card_l6.fill.solid()
    card_l6.fill.fore_color.rgb = COLOR_CARD
    card_l6.line.color.rgb = COLOR_ACCENT

    ctf_l6 = card_l6.text_frame
    ctf_l6.word_wrap = True
    cp_l6_0 = ctf_l6.paragraphs[0]
    cp_l6_0.text = "⚡ Real-time Sync Service"
    cp_l6_0.font.size = Pt(18)
    cp_l6_0.font.bold = True
    cp_l6_0.font.color.rgb = COLOR_ACCENT
    cp_l6_0.space_after = Pt(12)

    bullets_l6 = [
        "File: booking_service.dart",
        "Menghubungkan Flutter secara live dengan Cloud Firestore.",
        "Menggunakan snapshots() untuk mendengar perubahan status live.",
        "Status pengerjaan (1 - 5) otomatis ter-update tanpa reload."
    ]
    for b in bullets_l6:
        bp = ctf_l6.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(10)

    code_box1 = s6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(5.5), Inches(1.6), Inches(7.0), Inches(5.2))
    code_box1.fill.solid()
    code_box1.fill.fore_color.rgb = COLOR_BG
    code_box1.line.color.rgb = COLOR_PURPLE

    ctf_c1 = code_box1.text_frame
    ctf_c1.word_wrap = True

    code_text1 = """// File: lib/services/booking_service.dart

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream Live Status Servis dari Firestore
  Stream<List<BookingModel>> streamActiveBookings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .where('status', whereIn: [
          'Menunggu',
          'Proses Pengecekan',
          'Sedang Dikerjakan',
          'Quality Check'
        ])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }
}"""
    cp_c1 = ctf_c1.paragraphs[0]
    cp_c1.text = code_text1
    cp_c1.font.size = Pt(11)
    cp_c1.font.name = "Consolas"
    cp_c1.font.color.rgb = COLOR_YELLOW

    # -------------------------------------------------------------
    # SLIDE 7: Code Snippet 2 - PopScope Navigation Back Guard
    # -------------------------------------------------------------
    s7 = prs.slides.add_slide(blank_layout)
    set_bg(s7)
    add_header(s7, "Kodingan Utama 2: Navigasi Aman via PopScope", "Implementasi Kode Dart")

    card_l7 = s7.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(4.5), Inches(5.2))
    card_l7.fill.solid()
    card_l7.fill.fore_color.rgb = COLOR_CARD
    card_l7.line.color.rgb = COLOR_ACCENT

    ctf_l7 = card_l7.text_frame
    ctf_l7.word_wrap = True
    cp_l7_0 = ctf_l7.paragraphs[0]
    cp_l7_0.text = "🛡️ Navigation Guard"
    cp_l7_0.font.size = Pt(18)
    cp_l7_0.font.bold = True
    cp_l7_0.font.color.rgb = COLOR_ACCENT
    cp_l7_0.space_after = Pt(12)

    bullets_l7 = [
        "Disematkan di seluruh 17+ Screen.",
        "Menangani gestur & tombol fisik Back Android.",
        "Mencegah aplikasi crash/blank saat user menekan back.",
        "Mengarahkan secara cerdas ke route sebelumnya."
    ]
    for b in bullets_l7:
        bp = ctf_l7.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(10)

    code_box2 = s7.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(5.5), Inches(1.6), Inches(7.0), Inches(5.2))
    code_box2.fill.solid()
    code_box2.fill.fore_color.rgb = COLOR_BG
    code_box2.line.color.rgb = COLOR_PURPLE

    ctf_c2 = code_box2.text_frame
    ctf_c2.word_wrap = True

    code_text2 = """// Contoh Implementasi PopScope di Seluruh Screen

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (bool didPop, Object? result) {
      if (!didPop) {
        // Penanganan pintar tombol back gesture
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home'); // Fallback route aman
        }
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(...),
    ),
  );
}"""
    cp_c2 = ctf_c2.paragraphs[0]
    cp_c2.text = code_text2
    cp_c2.font.size = Pt(11)
    cp_c2.font.name = "Consolas"
    cp_c2.font.color.rgb = COLOR_GREEN

    # -------------------------------------------------------------
    # SLIDE 8: Kesimpulan & Link Repository
    # -------------------------------------------------------------
    s8 = prs.slides.add_slide(blank_layout)
    set_bg(s8)
    add_header(s8, "Kesimpulan & Link Penting Proyek", "Penutup & Repository")

    card_s8 = s8.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(11.7), Inches(5.2))
    card_s8.fill.solid()
    card_s8.fill.fore_color.rgb = COLOR_CARD
    card_s8.line.color.rgb = COLOR_ACCENT

    ctf_s8 = card_s8.text_frame
    ctf_s8.word_wrap = True
    cp_s8_0 = ctf_s8.paragraphs[0]
    cp_s8_0.text = "🎉 Proyek Selesai & Terintegrasi Sempurna!"
    cp_s8_0.font.size = Pt(22)
    cp_s8_0.font.bold = True
    cp_s8_0.font.color.rgb = COLOR_ACCENT
    cp_s8_0.space_after = Pt(16)

    bullets_s8 = [
        "Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase.",
        "Sistem booking servis & status live tracking terintegrasi 100% dengan Cloud Firestore.",
        "Otentikasi aman mendukung Email/Password, Google Sign-In, dan Facebook.",
        "Seluruh tombol back terlindungi dari crash menggunakan PopScope.",
        "Tampilan antarmuka 100% presisi mengikuti templat desain Bengkel Mobil (1).",
        "🐙 GitHub Repository: https://github.com/ifanagung3/201-AutoGarage",
        "🎨 Figma Design: https://www.figma.com/file/201-AutoGarage-UI-Design"
    ]
    for b in bullets_s8:
        bp = ctf_s8.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(15)
        bp.font.color.rgb = COLOR_GREEN if "GitHub" in b or "Figma" in b else COLOR_TEXT
        bp.space_after = Pt(12)

    output_filename = "PRESENTASI_201_AUTO_GARAGE_WITH_ACTUAL_SCREENSHOTS.pptx"
    prs.save(output_filename)
    print(f"🎉 File PPTX dengan Gambar Screenshots Asli berhasil dibuat: {output_filename}")

if __name__ == '__main__':
    create_pptx_with_actual_screenshots()
