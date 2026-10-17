import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.enum.text import PP_ALIGN
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

    # Slide 1: Cover Slide (Hero Title)
    s1 = prs.slides.add_slide(blank_layout)
    bg1 = s1.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
    bg1.fill.solid()
    bg1.fill.fore_color.rgb = COLOR_BG
    bg1.line.color.rgb = COLOR_BG

    # Hero Banner Card
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
    p1.text = "Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter & Firebase dengan Integrasi Random Forest"
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

        # Render Cards (Side by side or vertical grid)
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
                    bp.font.size = Pt(15)
                    bp.font.color.rgb = COLOR_TEXT
                    bp.space_after = Pt(10)

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
                    bp.font.size = Pt(14)
                    bp.font.color.rgb = COLOR_TEXT
                    bp.space_after = Pt(8)

        elif num_cards == 4:
            width = Inches(5.6)
            height = Inches(2.3)
            positions = [
                (Inches(0.8), Inches(1.8)),
                (Inches(6.8), Inches(1.8)),
                (Inches(0.8), Inches(4.4)),
                (Inches(6.8), Inches(4.4))
            ]
            for i, cdata in enumerate(cards_data):
                left, top = positions[i]
                card = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, top, width, height)
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
                cp.space_after = Pt(8)

                for b in cdata["items"]:
                    bp = ctf.add_paragraph()
                    bp.text = f"•  {b}"
                    bp.font.size = Pt(13)
                    bp.font.color.rgb = COLOR_TEXT
                    bp.space_after = Pt(4)

    # Slide 2: Problem Statement
    add_card_slide(
        "Latar Belakang & Tantangan Bengkel",
        "Masalah & Kebutuhan",
        [
            {
                "header": "🚗 Masalah Pelanggan",
                "items": [
                    "Antrean fisik yang panjang di lokasi bengkel.",
                    "Ketidakpastian biaya servis sebelum pengerjaan.",
                    "Kurangnya estimasi durasi pengerjaan yang akurat."
                ]
            },
            {
                "header": "📝 Masalah Operasional",
                "items": [
                    "Pengelolaan booking servis yang masih manual.",
                    "Resiko kesalahan penjadwalan mekanik.",
                    "Kebutuhan transparansi status pengerjaan kendaraan."
                ]
            }
        ]
    )

    # Slide 3: Solution
    add_card_slide(
        "Solusi Sistem: Aplikasi Mobile 201 Auto Garage",
        "Transformasi Digital Bengkel",
        [
            {
                "header": "📱 Pemesanan Mobile",
                "items": ["Booking jadwal servis mudah langsung dari aplikasi.", "Otentikasi aman via Email, Google & Facebook."]
            },
            {
                "header": "🤖 Machine Learning AI",
                "items": ["Prediksi estimasi biaya & durasi via Random Forest.", "Rekomendasi komponen perawatan otomatis."]
            },
            {
                "header": "📊 Real-time Tracking",
                "items": ["Pelacakan progres servis live berbasis Cloud Firestore.", "Bebas error navigasi berkat penanganan PopScope."]
            }
        ]
    )

    # Slide 4: Architecture
    add_card_slide(
        "Arsitektur Sistem Client-Server & AI REST API",
        "Infrastruktur Teknologi",
        [
            {
                "header": "1. Mobile App (Frontend)",
                "items": ["Flutter Framework (Dart) - Single Codebase.", "Support Android & iOS responsif.", "GoRouter & Custom State Management."]
            },
            {
                "header": "2. Backend & Cloud DB",
                "items": ["Firebase Authentication untuk otentikasi.", "Cloud Firestore NoSQL real-time database.", "Aturan keamanan Firestore Rules disesuaikan."]
            },
            {
                "header": "3. Machine Learning API",
                "items": ["Python REST API (Flask / FastAPI).", "Random Forest Regressor (scikit-learn).", "Client fallback otomatis di Flutter."]
            }
        ]
    )

    # Slide 5: ML Workflow
    add_card_slide(
        "Alur Prediksi Random Forest Regression",
        "Kecerdasan Buatan (Machine Learning)",
        [
            {
                "header": "1. Input Parameter",
                "items": ["Merk & Model Mobil", "Tahun Pembuatan", "Jarak Tempuh (KM)", "Jenis Layanan Servis", "Komponen Sparepart"]
            },
            {
                "header": "2. API Processing",
                "items": ["Flutter mengirim JSON payload", "Random Forest Regressor 100 Trees", "Kalkulasi Biaya & Durasi Jam"]
            },
            {
                "header": "3. Visual Output",
                "items": ["Display Estimasi Biaya (Rp)", "Display Durasi Waktu (Jam)", "Rekomendasi Perawatan AI"]
            }
        ]
    )

    # Slide 6: Metrics Highlights (Stats Callout Slide)
    s_metrics = prs.slides.add_slide(blank_layout)
    bg_m = s_metrics.shapes.add_shape(MSO_SHAPE.RECTANGLE, 0, 0, Inches(13.333), Inches(7.5))
    bg_m.fill.solid()
    bg_m.fill.fore_color.rgb = COLOR_BG
    bg_m.line.color.rgb = COLOR_BG

    tb_m = s_metrics.shapes.add_textbox(Inches(0.8), Inches(0.5), Inches(11.7), Inches(1.0))
    tf_m = tb_m.text_frame
    p_m0 = tf_m.paragraphs[0]
    p_m0.text = "EVALUASI KINERJA".upper()
    p_m0.font.size = Pt(12)
    p_m0.font.bold = True
    p_m0.font.color.rgb = COLOR_ACCENT

    p_m1 = tf_m.add_paragraph()
    p_m1.text = "Hasil Pengujian Model ML & Usability Application"
    p_m1.font.size = Pt(26)
    p_m1.font.bold = True
    p_m1.font.color.rgb = COLOR_TEXT

    # 4 Stat Callout Cards
    metrics_list = [
        {"value": "0.938", "label": "R-Squared (R²)", "sub": "Korelasi Sangat Akurat"},
        {"value": "4.82%", "label": "MAPE Error", "sub": "Tingkat Kesalahan < 5%"},
        {"value": "18.5k", "label": "RMSE (Rupiah)", "sub": "Galat Harga Terkontrol"},
        {"value": "84.5", "label": "Usability SUS", "sub": "Grade A (Excellent)"}
    ]

    for i, m in enumerate(metrics_list):
        left = Inches(0.8 + (i % 2) * 6.0)
        top = Inches(1.8 + (i // 2) * 2.6)
        card = s_metrics.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, top, Inches(5.6), Inches(2.3))
        card.fill.solid()
        card.fill.fore_color.rgb = COLOR_CARD
        card.line.color.rgb = COLOR_ACCENT

        ctf = card.text_frame
        ctf.word_wrap = True

        cp0 = ctf.paragraphs[0]
        cp0.text = m["value"]
        cp0.font.size = Pt(36)
        cp0.font.bold = True
        cp0.font.color.rgb = COLOR_GREEN if "84" in m["value"] or "0.9" in m["value"] else COLOR_ACCENT

        cp1 = ctf.add_paragraph()
        cp1.text = m["label"]
        cp1.font.size = Pt(18)
        cp1.font.bold = True
        cp1.font.color.rgb = COLOR_TEXT

        cp2 = ctf.add_paragraph()
        cp2.text = m["sub"]
        cp2.font.size = Pt(13)
        cp2.font.color.rgb = COLOR_MUTED

    # Slide 7: Conclusions
    add_card_slide(
        "Kesimpulan & Hasil Akhir",
        "Penutup",
        [
            {
                "header": "✅ Kesimpulan Utama",
                "items": [
                    "Sistem booking mobile 201 Auto Garage berhasil dibangun berbasis Flutter & Firebase.",
                    "Random Forest AI terbukti presisi tinggi memprediksi biaya & durasi pengerjaan.",
                    "Seluruh unit test dan pengujian navigasi PopScope lulus 100%."
                ]
            },
            {
                "header": "🚀 Rencana Pengembangan",
                "items": [
                    "Integrasi Payment Gateway digital (Midtrans / Xendit).",
                    "Penambahan Push Notification real-time via Firebase Cloud Messaging (FCM)."
                ]
            }
        ]
    )

    output_filename = "PRESENTASI_201_AUTO_GARAGE_PREMIUM.pptx"
    prs.save(output_filename)
    print(f"🎉 File PPTX Premium berhasil dibuat: {output_filename}")

if __name__ == '__main__':
    create_spectacular_pptx()
