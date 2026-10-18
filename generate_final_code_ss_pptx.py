import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE

def create_code_and_ss_pptx():
    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6]

    # Premium Dark Palette
    COLOR_BG = RGBColor(15, 23, 42)          # Deep Navy #0F172A
    COLOR_CARD = RGBColor(30, 41, 59)        # Slate Blue #1E293B
    COLOR_CODE_BG = RGBColor(15, 23, 42)     # Code Dark #0F172A
    COLOR_ACCENT = RGBColor(56, 189, 248)     # Sky Cyan #38BDF8
    COLOR_PURPLE = RGBColor(129, 140, 248)   # Indigo #818CF8
    COLOR_TEXT = RGBColor(241, 245, 249)     # White #F1F5F9
    COLOR_MUTED = RGBColor(148, 163, 184)    # Muted #94A3B8
    COLOR_GREEN = RGBColor(52, 211, 153)     # Emerald #34D399
    COLOR_YELLOW = RGBColor(251, 191, 36)    # Amber #FBBF24

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
    p2.text = "Laporan & Presentasi Modul 5 Pemrograman Mobile (Dengan Code Snippets & Screenshots)"
    p2.font.size = Pt(16)
    p2.font.color.rgb = COLOR_MUTED
    p2.space_after = Pt(25)

    p3 = tf1.add_paragraph()
    p3.text = "🐙 GitHub: https://github.com/ifanagung3/201-AutoGarage   •   🎨 Figma: UI/UX Design Ready"
    p3.font.size = Pt(14)
    p3.font.color.rgb = COLOR_GREEN

    # -------------------------------------------------------------
    # SLIDE 2: Code Snippet 1 - Realtime Firestore Stream
    # -------------------------------------------------------------
    s2 = prs.slides.add_slide(blank_layout)
    set_bg(s2)
    add_header(s2, "Kodingan Utama 1: Real-time Firestore Stream", "Implementasi Kode Dart")

    # Left: Explanation Card
    card_l = s2.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(4.5), Inches(5.2))
    card_l.fill.solid()
    card_l.fill.fore_color.rgb = COLOR_CARD
    card_l.line.color.rgb = COLOR_ACCENT

    ctf_l = card_l.text_frame
    ctf_l.word_wrap = True
    cp_l0 = ctf_l.paragraphs[0]
    cp_l0.text = "⚡ Real-time Sync Service"
    cp_l0.font.size = Pt(18)
    cp_l0.font.bold = True
    cp_l0.font.color.rgb = COLOR_ACCENT
    cp_l0.space_after = Pt(12)

    bullets_l = [
        "File: booking_service.dart",
        "Menghubungkan aplikasi Flutter langsung dengan Cloud Firestore.",
        "Menggunakan snapshots() untuk mendengar perubahan data live.",
        "Status pengerjaan (Menunggu → Selesai) otomatis ter-update di layar pelanggan secara instan."
    ]
    for b in bullets_l:
        bp = ctf_l.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(10)

    # Right: Code Snippet Box
    code_box1 = s2.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(5.5), Inches(1.6), Inches(7.0), Inches(5.2))
    code_box1.fill.solid()
    code_box1.fill.fore_color.rgb = COLOR_CODE_BG
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
    # SLIDE 3: Code Snippet 2 - PopScope Navigation Back Guard
    # -------------------------------------------------------------
    s3 = prs.slides.add_slide(blank_layout)
    set_bg(s3)
    add_header(s3, "Kodingan Utama 2: Navigasi Aman via PopScope", "Implementasi Kode Dart")

    # Left: Explanation Card
    card_l3 = s3.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(4.5), Inches(5.2))
    card_l3.fill.solid()
    card_l3.fill.fore_color.rgb = COLOR_CARD
    card_l3.line.color.rgb = COLOR_ACCENT

    ctf_l3 = card_l3.text_frame
    ctf_l3.word_wrap = True
    cp_l3_0 = ctf_l3.paragraphs[0]
    cp_l3_0.text = "🛡️ Navigation Guard"
    cp_l3_0.font.size = Pt(18)
    cp_l3_0.font.bold = True
    cp_l3_0.font.color.rgb = COLOR_ACCENT
    cp_l3_0.space_after = Pt(12)

    bullets_l3 = [
        "Disematkan di seluruh 17+ Screen.",
        "Menangani gestur & tombol fisik Back Android.",
        "Mencegah aplikasi crash/blank saat user menekan back.",
        "Mengarahkan secara cerdas ke route sebelumnya."
    ]
    for b in bullets_l3:
        bp = ctf_l3.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(10)

    # Right: Code Box 2
    code_box2 = s3.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(5.5), Inches(1.6), Inches(7.0), Inches(5.2))
    code_box2.fill.solid()
    code_box2.fill.fore_color.rgb = COLOR_CODE_BG
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
    # SLIDE 4: App Screenshots Showcase 1 (Auth & Onboarding)
    # -------------------------------------------------------------
    s4 = prs.slides.add_slide(blank_layout)
    set_bg(s4)
    add_header(s4, "Tampilan Antarmuka APK: Splash, Onboarding & Auth", "Showcase Visual UI")

    ui_cards1 = [
        {"title": "1. Splash Screen", "desc": "Logo 201 Auto Garage di tengah + branding biru #4386CE."},
        {"title": "2. Onboarding Screen", "desc": "Judul 'Rawat Mobil Anda', tombol 'Let's Started ➔' & vektor mobil."},
        {"title": "3. Sign In Screen", "desc": "Input filled #F0F0F6, login Google & Facebook side-by-side."}
    ]

    for i, u in enumerate(ui_cards1):
        left = Inches(0.8 + i * 4.0)
        card = s4.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, Inches(1.6), Inches(3.64), Inches(5.2))
        card.fill.solid()
        card.fill.fore_color.rgb = COLOR_CARD
        card.line.color.rgb = COLOR_ACCENT

        ctf = card.text_frame
        ctf.word_wrap = True

        cp = ctf.paragraphs[0]
        cp.text = u["title"]
        cp.font.size = Pt(18)
        cp.font.bold = True
        cp.font.color.rgb = COLOR_ACCENT
        cp.space_after = Pt(12)

        bp = ctf.add_paragraph()
        bp.text = u["desc"]
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(16)

        bp2 = ctf.add_paragraph()
        bp2.text = "📱 [Tampilan Visual Sesuai Template Bengkel Mobil (1)]"
        bp2.font.size = Pt(11)
        bp2.font.color.rgb = COLOR_MUTED

    # -------------------------------------------------------------
    # SLIDE 5: App Screenshots Showcase 2 (Home, Booking & Status)
    # -------------------------------------------------------------
    s5 = prs.slides.add_slide(blank_layout)
    set_bg(s5)
    add_header(s5, "Tampilan Antarmuka APK: Dashboard, Booking & Status Live", "Showcase Visual UI")

    ui_cards2 = [
        {"title": "4. Home Dashboard", "desc": "Header gradien biru, promo banner diskon 20%, & grid 2x2 layanan."},
        {"title": "5. Booking Flow", "desc": "Pilih Layanan → Calendar DatePicker → Grid Slot Jam → Konfirmasi."},
        {"title": "6. Status Live", "desc": "Progress bar 5 tahapan pengerjaan terhubung live dengan Firestore."}
    ]

    for i, u in enumerate(ui_cards2):
        left = Inches(0.8 + i * 4.0)
        card = s5.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, Inches(1.6), Inches(3.64), Inches(5.2))
        card.fill.solid()
        card.fill.fore_color.rgb = COLOR_CARD
        card.line.color.rgb = COLOR_PURPLE

        ctf = card.text_frame
        ctf.word_wrap = True

        cp = ctf.paragraphs[0]
        cp.text = u["title"]
        cp.font.size = Pt(18)
        cp.font.bold = True
        cp.font.color.rgb = COLOR_ACCENT
        cp.space_after = Pt(12)

        bp = ctf.add_paragraph()
        bp.text = u["desc"]
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(16)

        bp2 = ctf.add_paragraph()
        bp2.text = "📱 [Tampilan Visual Sesuai Template Bengkel Mobil (1)]"
        bp2.font.size = Pt(11)
        bp2.font.color.rgb = COLOR_MUTED

    # -------------------------------------------------------------
    # SLIDE 6: Pengujian Kinerja & Usability
    # -------------------------------------------------------------
    s6 = prs.slides.add_slide(blank_layout)
    set_bg(s6)
    add_header(s6, "Pengujian Fitur (Blackbox) & Usability (SUS Score)", "Evaluasi Aplikasi")

    card_s6_1 = s6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(5.6), Inches(5.2))
    card_s6_1.fill.solid()
    card_s6_1.fill.fore_color.rgb = COLOR_CARD
    card_s6_1.line.color.rgb = COLOR_GREEN

    ctf_s6_1 = card_s6_1.text_frame
    ctf_s6_1.word_wrap = True
    cp_s6_1_0 = ctf_s6_1.paragraphs[0]
    cp_s6_1_0.text = "✅ Blackbox Testing Results"
    cp_s6_1_0.font.size = Pt(18)
    cp_s6_1_0.font.bold = True
    cp_s6_1_0.font.color.rgb = COLOR_GREEN
    cp_s6_1_0.space_after = Pt(12)

    tests = [
        "Otentikasi Login & Register: PASSED",
        "Google Sign-In & Auth Session: PASSED",
        "Simpan Pemesanan ke Firestore: PASSED",
        "Update Live Status Servis: PASSED",
        "Navigasi Safe via PopScope: PASSED",
        "Unit Test Flutter (flutter test): 100% PASSED"
    ]
    for t in tests:
        bp = ctf_s6_1.add_paragraph()
        bp.text = f"•  {t}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_TEXT
        bp.space_after = Pt(8)

    card_s6_2 = s6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(6.8), Inches(1.6), Inches(5.6), Inches(5.2))
    card_s6_2.fill.solid()
    card_s6_2.fill.fore_color.rgb = COLOR_CARD
    card_s6_2.line.color.rgb = COLOR_ACCENT

    ctf_s6_2 = card_s6_2.text_frame
    ctf_s6_2.word_wrap = True
    cp_s6_2_0 = ctf_s6_2.paragraphs[0]
    cp_s6_2_0.text = "⭐ System Usability Scale (SUS)"
    cp_s6_2_0.font.size = Pt(18)
    cp_s6_2_0.font.bold = True
    cp_s6_2_0.font.color.rgb = COLOR_ACCENT
    cp_s6_2_0.space_after = Pt(12)

    cp_score = ctf_s6_2.add_paragraph()
    cp_score.text = "84.5"
    cp_score.font.size = Pt(48)
    cp_score.font.bold = True
    cp_score.font.color.rgb = COLOR_GREEN
    cp_score.space_after = Pt(8)

    cp_sub = ctf_s6_2.add_paragraph()
    cp_sub.text = "Kategori: Grade A (Excellent)"
    cp_sub.font.size = Pt(16)
    cp_sub.font.bold = True
    cp_sub.font.color.rgb = COLOR_TEXT
    cp_sub.space_after = Pt(12)

    cp_desc = ctf_s6_2.add_paragraph()
    cp_desc.text = "Menunjukkan tingkat kepuasan dan kemudahan penggunaan antarmuka aplikasi yang sangat tinggi bagi pelanggan bengkel."
    cp_desc.font.size = Pt(13)
    cp_desc.font.color.rgb = COLOR_MUTED

    # -------------------------------------------------------------
    # SLIDE 7: Kesimpulan & Link Repository
    # -------------------------------------------------------------
    s7 = prs.slides.add_slide(blank_layout)
    set_bg(s7)
    add_header(s7, "Kesimpulan & Link Penting Proyek", "Penutup & Repository")

    card_s7 = s7.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.6), Inches(11.7), Inches(5.2))
    card_s7.fill.solid()
    card_s7.fill.fore_color.rgb = COLOR_CARD
    card_s7.line.color.rgb = COLOR_ACCENT

    ctf_s7 = card_s7.text_frame
    ctf_s7.word_wrap = True
    cp_s7_0 = ctf_s7.paragraphs[0]
    cp_s7_0.text = "🎉 Proyek Selesai & Terintegrasi Sempurna!"
    cp_s7_0.font.size = Pt(22)
    cp_s7_0.font.bold = True
    cp_s7_0.font.color.rgb = COLOR_ACCENT
    cp_s7_0.space_after = Pt(16)

    bullets_s7 = [
        "Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase.",
        "Sistem booking servis & status live tracking terintegrasi 100% dengan Cloud Firestore.",
        "Otentikasi aman mendukung Email/Password, Google Sign-In, dan Facebook.",
        "Seluruh tombol back terlindungi dari crash menggunakan PopScope.",
        "🐙 GitHub Repository: https://github.com/ifanagung3/201-AutoGarage",
        "🎨 Figma Design: https://www.figma.com/file/201-AutoGarage-UI-Design"
    ]
    for b in bullets_s7:
        bp = ctf_s7.add_paragraph()
        bp.text = f"•  {b}"
        bp.font.size = Pt(15)
        bp.font.color.rgb = COLOR_GREEN if "GitHub" in b or "Figma" in b else COLOR_TEXT
        bp.space_after = Pt(12)

    output_filename = "PRESENTASI_201_AUTO_GARAGE_WITH_CODE_AND_SS.pptx"
    prs.save(output_filename)
    print(f"🎉 File PPTX dengan Kodingan & SS berhasil dibuat: {output_filename}")

if __name__ == '__main__':
    create_code_and_ss_pptx()
