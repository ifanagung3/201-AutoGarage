import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE

def build_kelompok6_presentation():
    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6]

    # Color Palette - Kelompok 6 Style (Clean White Background, Vibrant Orange/Blue Accents, Dark Text)
    COLOR_BG = RGBColor(255, 255, 255)         # Clean White
    COLOR_CARD = RGBColor(248, 250, 252)       # Light Slate #F8FAFC
    COLOR_ORANGE = RGBColor(249, 115, 22)      # Kelompok 6 Signature Orange #F97316
    COLOR_BLUE = RGBColor(59, 130, 246)        # Royal Blue #3B82F6
    COLOR_DARK = RGBColor(23, 29, 56)          # Dark Ink #171D38
    COLOR_MUTED = RGBColor(100, 116, 139)      # Slate Muted #64748B
    COLOR_CODE_BG = RGBColor(15, 23, 42)      # Code Dark #0F172A
    COLOR_GREEN = RGBColor(16, 185, 129)       # Success Green #10B981

    img_folder = r"C:\Users\ASUS\Downloads\Bengkel Mobil (1)"

    def set_white_bg(slide):
        bg = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
        bg.fill.solid()
        bg.fill.fore_color.rgb = COLOR_BG
        bg.line.color.rgb = COLOR_BG

    def add_top_bar(slide, title, slide_num):
        # Top title text
        tb = slide.shapes.add_textbox(Inches(0.8), Inches(0.4), Inches(11.0), Inches(0.9))
        tf = tb.text_frame
        tf.word_wrap = True
        p = tf.paragraphs[0]
        p.text = title
        p.font.size = Pt(24)
        p.font.bold = True
        p.font.color.rgb = COLOR_DARK

        # Slide Number Badge
        num_box = slide.shapes.add_textbox(Inches(12.0), Inches(0.4), Inches(0.8), Inches(0.5))
        np = num_box.text_frame.paragraphs[0]
        np.text = str(slide_num)
        np.font.size = Pt(16)
        np.font.bold = True
        np.font.color.rgb = COLOR_ORANGE

    # =============================================================
    # SLIDE 1: Cover Title (Morrow Coffee / Kelompok 6 Layout)
    # =============================================================
    s1 = prs.slides.add_slide(blank_layout)
    set_white_bg(s1)

    # Accent Card Banner
    card1 = s1.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(0.8), Inches(11.733), Inches(5.9))
    card1.fill.solid()
    card1.fill.fore_color.rgb = COLOR_CARD
    card1.line.color.rgb = COLOR_ORANGE
    card1.line.width = Pt(2)

    tf1 = card1.text_frame
    tf1.word_wrap = True

    p0 = tf1.paragraphs[0]
    p0.text = "Implementasi Navigasi Halaman"
    p0.font.size = Pt(32)
    p0.font.bold = True
    p0.font.color.rgb = COLOR_ORANGE
    p0.space_after = Pt(6)

    p1 = tf1.add_paragraph()
    p1.text = "pada Aplikasi 201 Auto Garage"
    p1.font.size = Pt(32)
    p1.font.bold = True
    p1.font.color.rgb = COLOR_DARK
    p1.space_after = Pt(16)

    p2 = tf1.add_paragraph()
    p2.text = "Pemrograman Mobile · Pertemuan 5: Navigasi dan Multi-Screen"
    p2.font.size = Pt(18)
    p2.font.bold = True
    p2.font.color.rgb = COLOR_BLUE
    p2.space_after = Pt(28)

    p3 = tf1.add_paragraph()
    p3.text = "Anggota Kelompok :\n1. Ahmad Fauzi - 20230801001\n2. Risma Dwi Purwandini - 20230801079\n3. Randy Adriansyah - 20230801131\n4. Aushof Ahmad Fatinun Naim - 20230801052"
    p3.font.size = Pt(14)
    p3.font.color.rgb = COLOR_DARK

    # =============================================================
    # SLIDE 2: User Flow Aplikasi (3 Halaman Inti Oranye)
    # =============================================================
    s2 = prs.slides.add_slide(blank_layout)
    set_white_bg(s2)
    add_top_bar(s2, "User Flow Aplikasi 201 Auto Garage", 2)

    # Subtitle text
    tb2 = s2.shapes.add_textbox(Inches(0.8), Inches(1.2), Inches(11.733), Inches(0.6))
    p2_sub = tb2.text_frame.paragraphs[0]
    p2_sub.text = "17 layar mobile · 4 halaman inti (oranye) · cabang navigasi aman PopScope"
    p2_sub.font.size = Pt(15)
    p2_sub.font.color.rgb = COLOR_MUTED

    # 3 Core Pages Cards
    flow_cards = [
        {"title": "1. Home / Menu (01)", "desc": "Header salam, search bar, banner promo diskon 20%, & grid 2x2 pilihan layanan.", "color": COLOR_ORANGE},
        {"title": "2. Booking Wizard (02)", "desc": "Alur pemesanan berantai: Pilih Layanan → Pilih Tanggal → Pilih Jam → Konfirmasi.", "color": COLOR_ORANGE},
        {"title": "3. Status Servis Live (03)", "desc": "Progress bar 5 tahapan pengerjaan real-time terhubung langsung dengan Firestore.", "color": COLOR_ORANGE},
    ]

    for i, fc in enumerate(flow_cards):
        left_pos = Inches(0.8 + i * 4.0)
        card = s2.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left_pos, Inches(2.0), Inches(3.64), Inches(4.8))
        card.fill.solid()
        card.fill.fore_color.rgb = COLOR_CARD
        card.line.color.rgb = fc["color"]
        card.line.width = Pt(2)

        ctf = card.text_frame
        ctf.word_wrap = True
        cp = ctf.paragraphs[0]
        cp.text = fc["title"]
        cp.font.size = Pt(18)
        cp.font.bold = True
        cp.font.color.rgb = fc["color"]
        cp.space_after = Pt(12)

        bp = ctf.add_paragraph()
        bp.text = fc["desc"]
        bp.font.size = Pt(14)
        bp.font.color.rgb = COLOR_DARK
        bp.space_after = Pt(16)

        bp2 = ctf.add_paragraph()
        bp2.text = "• Bottom navigation memberi jalan pintas ke Beranda, Status, Riwayat, dan Akun."
        bp2.font.size = Pt(12)
        bp2.font.color.rgb = COLOR_MUTED

    # =============================================================
    # SLIDE 3: Hasil Implementasi: Tiga Halaman Inti (Dengan Screenshots PNG)
    # =============================================================
    s3 = prs.slides.add_slide(blank_layout)
    set_white_bg(s3)
    add_top_bar(s3, "Hasil Implementasi: Tiga Halaman Inti", 3)

    ss_items = [
        {"title": "Home / Menu", "sub": "Daftar layanan, pencarian, promo", "file": "Dashboard.png"},
        {"title": "Booking Servis", "sub": "Pilih layanan, tanggal & jam", "file": "Booking Servis.png"},
        {"title": "Status Servis", "sub": "Progress bar 5 tahapan live", "file": "Status Servis.png"}
    ]

    for i, item in enumerate(ss_items):
        left_pos = Inches(0.8 + i * 4.0)

        # Header Box
        tb_ss = s3.shapes.add_textbox(left_pos, Inches(1.3), Inches(3.64), Inches(0.8))
        tf_ss = tb_ss.text_frame
        p_t = tf_ss.paragraphs[0]
        p_t.text = item["title"]
        p_t.font.size = Pt(16)
        p_t.font.bold = True
        p_t.font.color.rgb = COLOR_ORANGE

        p_s = tf_ss.add_paragraph()
        p_s.text = item["sub"]
        p_s.font.size = Pt(12)
        p_s.font.color.rgb = COLOR_MUTED

        # PNG Image
        img_path = os.path.join(img_folder, item["file"])
        if os.path.exists(img_path):
            s3.shapes.add_picture(img_path, left_pos, Inches(2.2), height=Inches(4.8))

    # =============================================================
    # SLIDE 4: Navigasi Antarhalaman dan Passing Data (Tabel + Code)
    # =============================================================
    s4 = prs.slides.add_slide(blank_layout)
    set_white_bg(s4)
    add_top_bar(s4, "Navigasi Antarhalaman dan Passing Data", 4)

    # Left: Table
    table_card = s4.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.4), Inches(6.8), Inches(5.4))
    table_card.fill.solid()
    table_card.fill.fore_color.rgb = COLOR_CARD
    table_card.line.color.rgb = COLOR_ORANGE

    ctf_t = table_card.text_frame
    ctf_t.word_wrap = True
    cp_t0 = ctf_t.paragraphs[0]
    cp_t0.text = "📋 Alur Perpindahan & Passing Data"
    cp_t0.font.size = Pt(16)
    cp_t0.font.bold = True
    cp_t0.font.color.rgb = COLOR_ORANGE
    cp_t0.space_after = Pt(10)

    rows = [
        "Home ➔ Kartu Layanan ➔ Booking Layanan (Data: Jenis Servis)",
        "Booking Layanan ➔ Pilih Tanggal ➔ Booking Tanggal (Data: Service Name)",
        "Booking Tanggal ➔ Pilih Waktu ➔ Booking Waktu (Data: Date)",
        "Booking Waktu ➔ Lanjut ➔ Konfirmasi Booking (Data: Date + Time)",
        "Home ➔ Ikon Status (Bottom Nav) ➔ Status Servis Live"
    ]
    for r in rows:
        bp = ctf_t.add_paragraph()
        bp.text = f"•  {r}"
        bp.font.size = Pt(12)
        bp.font.color.rgb = COLOR_DARK
        bp.space_after = Pt(10)

    # Right: Code Box
    code_box = s4.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(7.8), Inches(1.4), Inches(4.733), Inches(5.4))
    code_box.fill.solid()
    code_box.fill.fore_color.rgb = COLOR_CODE_BG
    code_box.line.color.rgb = COLOR_BLUE

    ctf_c = code_box.text_frame
    ctf_c.word_wrap = True

    code_text = """// Home -> Booking Tanggal
context.go('/booking/tanggal');

// Back Handling via PopScope
PopScope(
  canPop: false,
  onPopInvokedWithResult:
    (bool didPop, Object? result) {
    if (!didPop) {
      context.pop();
    }
  },
  child: Scaffold(...),
);

// Data dikirim: Object BookingModel
// dari Home ke Konfirmasi & Firestore"""

    cp_c = ctf_c.paragraphs[0]
    cp_c.text = code_text
    cp_c.font.size = Pt(11)
    cp_c.font.name = "Consolas"
    cp_c.font.color.rgb = COLOR_GREEN

    # =============================================================
    # SLIDE 5: Pengujian Tombol Back dan Alur Kembali (Tabel Blackbox Test)
    # =============================================================
    s5 = prs.slides.add_slide(blank_layout)
    set_white_bg(s5)
    add_top_bar(s5, "Pengujian Tombol Back dan Alur Kembali", 5)

    card5 = s5.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.4), Inches(11.733), Inches(5.4))
    card5.fill.solid()
    card5.fill.fore_color.rgb = COLOR_CARD
    card5.line.color.rgb = COLOR_ORANGE

    ctf5 = card5.text_frame
    ctf5.word_wrap = True

    cp5_0 = ctf5.paragraphs[0]
    cp5_0.text = "🧪 Tabel Pengujian Blackbox Navigasi & Back Button"
    cp5_0.font.size = Pt(18)
    cp5_0.font.bold = True
    cp5_0.font.color.rgb = COLOR_ORANGE
    cp5_0.space_after = Pt(14)

    test_rows = [
        "1. Home ➔ Servis Rutin ➔ Back  |  Hasil Expected: Detail Tampil, Back ke Home  |  Status: BERHASIL",
        "2. Home ➔ Booking ➔ Tanggal ➔ Waktu ➔ Back  |  Hasil Expected: Kembali ke Tanggal, lalu Home  |  Status: BERHASIL",
        "3. Home ➔ Ikon Status (Bottom Nav) ➔ Back  |  Hasil Expected: Kembali ke Home  |  Status: BERHASIL",
        "4. Konfirmasi Booking ➔ Submit ➔ Status Servis  |  Hasil Expected: Masuk ke Status Live Firestore  |  Status: BERHASIL",
        "5. Back di Home  |  Hasil Expected: Keluar aplikasi tanpa error via PopScope  |  Status: BERHASIL"
    ]

    for tr in test_rows:
        bp = ctf5.add_paragraph()
        bp.text = f"•  {tr}"
        bp.font.size = Pt(13)
        bp.font.color.rgb = COLOR_DARK
        bp.space_after = Pt(12)

    # =============================================================
    # SLIDE 6: Ringkasan Kuis / Konsep Navigasi Modul 5
    # =============================================================
    s6 = prs.slides.add_slide(blank_layout)
    set_white_bg(s6)
    add_top_bar(s6, "Ringkasan Konsep Navigasi Modul 5", 6)

    quiz_items = [
        {"title": "Fungsi Navigasi", "desc": "Perpindahan antarhalaman agar pengguna tahu posisi dan cepat mencapai fitur."},
        {"title": "Stack vs Bottom Nav", "desc": "Stack menumpuk halaman (Home ➔ Booking ➔ Konfirmasi); bottom nav memberi akses cepat ke fitur utama."},
        {"title": "Route & PopScope", "desc": "Alamat halaman yang dipakai router dan pengaman tombol back fisik Android."},
        {"title": "User Flow", "desc": "Dirancang sejak awal agar alur jelas dan langkah pemesanan tidak berlebihan."},
        {"title": "Menguji Navigasi", "desc": "Coba semua tombol dan gesture back di emulator, pastikan data tersimpan di Firestore."}
    ]

    for i, q in enumerate(quiz_items):
        left_pos = Inches(0.8)
        top_pos = Inches(1.4 + i * 1.05)
        qcard = s6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left_pos, top_pos, Inches(11.733), Inches(0.9))
        qcard.fill.solid()
        qcard.fill.fore_color.rgb = COLOR_CARD
        qcard.line.color.rgb = COLOR_BLUE

        qtf = qcard.text_frame
        qtf.word_wrap = True
        qp0 = qtf.paragraphs[0]
        qp0.text = f"{q['title']}  —  {q['desc']}"
        qp0.font.size = Pt(13)
        qp0.font.color.rgb = COLOR_DARK

    # =============================================================
    # SLIDE 7: Kesimpulan & Link Repository (Kelompok 6 Style)
    # =============================================================
    s7 = prs.slides.add_slide(blank_layout)
    set_white_bg(s7)
    add_top_bar(s7, "Kesimpulan", 7)

    card7 = s7.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.4), Inches(11.733), Inches(5.4))
    card7.fill.solid()
    card7.fill.fore_color.rgb = COLOR_CARD
    card7.line.color.rgb = COLOR_ORANGE
    card7.line.width = Pt(2)

    ctf7 = card7.text_frame
    ctf7.word_wrap = True

    conclusions = [
        "201 Auto Garage kini punya empat halaman inti yang saling terhubung: Home/Menu, Booking Wizard, Status Live, dan Akun.",
        "Stack navigation dan bottom navigation membuat perpindahan halaman jelas, dengan tombol back yang konsisten via PopScope.",
        "Objek pemesanan dikirim dari Home ke Konfirmasi sebagai bentuk passing data dan tersimpan secara real-time ke Cloud Firestore.",
        "User flow yang dirancang sejak awal dapat dikembangkan sampai pelacakan status pengerjaan servis secara live."
    ]

    for c in conclusions:
        bp = ctf7.add_paragraph()
        bp.text = f"•  {c}"
        bp.font.size = Pt(15)
        bp.font.color.rgb = COLOR_DARK
        bp.space_after = Pt(14)

    p_links = ctf7.add_paragraph()
    p_links.text = "🐙 GitHub: https://github.com/ifanagung3/201-AutoGarage\n🎨 Figma: 201 Auto Garage - Mobile Ordering UI"
    p_links.font.size = Pt(15)
    p_links.font.bold = True
    p_links.font.color.rgb = COLOR_BLUE

    output_filename = "PRESENTASI_MODUL_5_KELOMPOK_6_EXACT_STYLE.pptx"
    prs.save(output_filename)
    print(f"🎉 File PPTX Exact Kelompok 6 Style berhasil dibuat: {output_filename}")

if __name__ == '__main__':
    build_kelompok6_presentation()
