import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.shapes import MSO_SHAPE

def create_spectacular_pptx():
    prs = Presentation()
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6]

    # Color Palette - Premium Modern Dark Tech
    COLOR_BG = RGBColor(15, 23, 42)          # Deep Navy #0F172A
    COLOR_CARD = RGBColor(30, 41, 59)        # Slate Blue #1E293B
    COLOR_ACCENT = RGBColor(56, 189, 248)     # Sky Cyan #38BDF8
    COLOR_PURPLE = RGBColor(129, 140, 248)   # Indigo #818CF8
    COLOR_TEXT = RGBColor(241, 245, 249)     # Bright White #F1F5F9
    COLOR_MUTED = RGBColor(148, 163, 184)    # Slate Muted #94A3B8
    COLOR_GREEN = RGBColor(52, 211, 153)     # Emerald #34D399

    # Slide 1: Cover Slide
    s1 = prs.slides.add_slide(blank_layout)
    bg1 = s1.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
    bg1.fill.solid()
    bg1.fill.fore_color.rgb = COLOR_BG
    bg1.line.color.rgb = COLOR_BG

    hero = s1.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(0.8), Inches(11.7), Inches(5.9))
    hero.fill.solid()
    hero.fill.fore_color.rgb = COLOR_CARD
    hero.line.color.rgb = COLOR_ACCENT

    tf1 = hero.text_frame
    tf1.word_wrap = True

    p0 = tf1.paragraphs[0]
    p0.text = "🚗 201 AUTO GARAGE"
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
    p2.text = "Laporan & Presentasi Modul 5 Pemrograman Mobile"
    p2.font.size = Pt(18)
    p2.font.color.rgb = COLOR_MUTED
    p2.space_after = Pt(30)

    p3 = tf1.add_paragraph()
    p3.text = "🐙 GitHub: https://github.com/ifanagung3/201-AutoGarage   •   🎨 Figma: UI/UX Design Ready"
    p3.font.size = Pt(14)
    p3.font.color.rgb = COLOR_GREEN

    # Helper function to add a standard slide with cards
    def add_card_slide(title, category, cards_data):
        slide = prs.slides.add_slide(blank_layout)
        bg = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
        bg.fill.solid()
        bg.fill.fore_color.rgb = COLOR_BG
        bg.line.color.rgb = COLOR_BG

        # Title
        tb = slide.shapes.add_textbox(Inches(0.8), Inches(0.5), Inches(11.7), Inches(1.0))
        tf = tb.text_frame
        tf.word_wrap = True

        p_cat = tf.paragraphs[0]
        p_cat.text = category.upper()
        p_cat.font.size = Pt(12)
        p_cat.font.bold = True
        p_cat.font.color.rgb = COLOR_ACCENT

        p_t = tf.add_paragraph()
        p_t.text = title
        p_t.font.size = Pt(26)
        p_t.font.bold = True
        p_t.font.color.rgb = COLOR_TEXT

        num_cards = len(cards_data)
        if num_cards == 2:
            width = Inches(5.6)
            for i, cdata in enumerate(cards_data):
                left = Inches(0.8 + i * 6.0)
                card = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, Inches(1.8), width, Inches(5.0))
                card.fill.solid()
                card.fill.fore_color.rgb = COLOR_CARD
                card.line.color.rgb = COLOR_PURPLE if i == 1 else COLOR_ACCENT

                ctf = card.text_frame
                ctf.word_wrap = True
                cp = ctf.paragraphs[0]
                cp.text = cdata["header"]
                cp.font.size = Pt(20)
                cp.font.bold = True
                cp.font.color.rgb = COLOR_ACCENT
                cp.space_after = Pt(14)

                for b in cdata["items"]:
                    bp = ctf.add_paragraph()
                    bp.text = f"•  {b}"
                    bp.font.size = Pt(14)
                    bp.font.color.rgb = COLOR_TEXT
                    bp.space_after = Pt(8)

        elif num_cards == 3:
            width = Inches(3.64)
            for i, cdata in enumerate(cards_data):
                left = Inches(0.8 + i * 4.0)
                card = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, Inches(1.8), width, Inches(5.0))
                card.fill.solid()
                card.fill.fore_color.rgb = COLOR_CARD
                card.line.color.rgb = COLOR_ACCENT

                ctf = card.text_frame
                ctf.word_wrap = True
                cp = ctf.paragraphs[0]
                cp.text = cdata["header"]
                cp.font.size = Pt(18)
                cp.font.bold = True
                cp.font.color.rgb = COLOR_ACCENT
                cp.space_after = Pt(12)

                for b in cdata["items"]:
                    bp = ctf.add_paragraph()
                    bp.text = f"•  {b}"
                    bp.font.size = Pt(13)
                    bp.font.color.rgb = COLOR_TEXT
                    bp.space_after = Pt(8)

    # Slide 2: Problem Statement
    add_card_slide(
        "Latar Belakang & Tantangan Bengkel",
        "Masalah & Kebutuhan",
        [
            {
                "header": "🚗 Masalah Pelanggan",
                "items": [
                    "Antrean fisik yang panjang di lokasi bengkel.",
                    "Keterbatasan akses informasi jadwal ketersediaan pengerjaan.",
                    "Kebutuhan transparansi status pengerjaan kendaraan."
                ]
            },
            {
                "header": "📝 Masalah Operasional",
                "items": [
                    "Pengelolaan booking servis yang masih manual.",
                    "Resiko penumpukan jadwal dan kesalahan pencatatan.",
                    "Kebutuhan dashboard terpusat untuk administrator bengkel."
                ]
            }
        ]
    )

    # Slide 3: Solution & UI Showcase
    add_card_slide(
        "Solusi & Tampilan Utama Antarmuka App (UI Showcase)",
        "Fitur & Desain Antarmuka",
        [
            {
                "header": "🎨 Visual Theme & Style",
                "items": [
                    "Splash & Onboarding: Branding logo 201 Auto Garage.",
                    "Auth Screens: Input box filled abu-abu (#F5F5F5) tanpa border.",
                    "Home Dashboard: Header gradien, salam pelanggan, banner promo & grid 2x2."
                ]
            },
            {
                "header": "📱 Modul Pengguna",
                "items": [
                    "Sign In & Sign Up: Login via Email, Google & Facebook.",
                    "Booking Wizard Flow: Layanan → Tanggal → Jam → Konfirmasi.",
                    "Status Servis Live: Progress bar 5 tahapan pengerjaan."
                ]
            }
        ]
    )

    # Slide 4: Code Implementation
    add_card_slide(
        "Implementasi Kode Program Utama (Code Snippets)",
        "Struktur Kode & Logika Dart",
        [
            {
                "header": "🔄 Firestore Live Stream Code",
                "items": [
                    "_db.collection('bookings').snapshots()",
                    "Status Live: Menunggu → Pengecekan → Pengerjaan → Quality Check → Selesai",
                    "Otomatis update tampilan tanpa reload."
                ]
            },
            {
                "header": "🛡️ Navigation Back Guard (PopScope)",
                "items": [
                    "PopScope(canPop: false, onPopInvokedWithResult: ...)",
                    "Mencegah app crash pada gesture back Android.",
                    "Mengarahkan dengan aman ke route sebelumnya."
                ]
            },
            {
                "header": "🔑 Firebase Auth Integration",
                "items": [
                    "FirebaseAuth.instance.signInWithEmailAndPassword()",
                    "Dukungan Login Google Sign-In & Facebook.",
                    "Manajemen profil pengguna terintegrasi."
                ]
            }
        ]
    )

    # Slide 5: Conclusions & Usability
    add_card_slide(
        "Kesimpulan & Hasil Pengujian Sistem",
        "Penutup",
        [
            {
                "header": "✅ Kesimpulan Utama",
                "items": [
                    "Aplikasi mobile 201 Auto Garage berhasil dibangun berbasis Flutter & Firebase.",
                    "Sistem pelacakan real-time Firestore berfungsi lancar.",
                    "Seluruh pengujian Blackbox & Unit Test lulus 100% (All tests passed!)."
                ]
            },
            {
                "header": "⭐ Skoring Usability",
                "items": [
                    "Pengujian System Usability Scale (SUS) mencapai skor 84.5.",
                    "Kategori Grade A (Excellent) diterima pengguna."
                ]
            }
        ]
    )

    output_filename = "PRESENTASI_201_AUTO_GARAGE_FINAL.pptx"
    prs.save(output_filename)
    print(f"🎉 File PPTX Final berhasil dibuat: {output_filename}")

if __name__ == '__main__':
    create_spectacular_pptx()
