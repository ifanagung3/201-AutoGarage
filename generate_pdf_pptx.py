import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

def generate_pdf():
    pdf_path = "LAPORAN_MODUL_5_201_AUTO_GARAGE.pdf"
    doc = SimpleDocTemplate(pdf_path, pagesize=letter, rightMargin=40, leftMargin=40, topMargin=40, bottomMargin=40)
    styles = getSampleStyleSheet()

    # Custom Styles
    title_style = ParagraphStyle(
        'TitleStyle',
        parent=styles['Heading1'],
        fontSize=18,
        leading=22,
        textColor=colors.HexColor('#1E293B'),
        alignment=1, # Center
        spaceAfter=15
    )

    h1_style = ParagraphStyle(
        'H1Style',
        parent=styles['Heading2'],
        fontSize=13,
        leading=16,
        textColor=colors.HexColor('#5B8DEF'),
        spaceBefore=14,
        spaceAfter=6
    )

    body_style = ParagraphStyle(
        'BodyStyle',
        parent=styles['Normal'],
        fontSize=10,
        leading=14,
        textColor=colors.HexColor('#334155'),
        spaceAfter=6
    )

    bullet_style = ParagraphStyle(
        'BulletStyle',
        parent=body_style,
        leftIndent=15,
        spaceAfter=4
    )

    story = []

    # Title & Header
    story.append(Paragraph("LAPORAN PEMROGRAMAN MOBILE (MODUL 5)", title_style))
    story.append(Paragraph("<b>RANCANG BANGUN APLIKASI MOBILE BOOKING SERVIS MOBIL BERBASIS FLUTTER DAN FIREBASE PADA BENGKEL 201 AUTO GARAGE</b>", ParagraphStyle('SubTitle', parent=body_style, alignment=1, fontSize=11, leading=15)))
    story.append(Spacer(1, 15))
    story.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor('#5B8DEF'), spaceAfter=15))

    # Identitas Proyek
    story.append(Paragraph("<b>INFORMASI PROYEK & REPOSITORY:</b>", h1_style))
    story.append(Paragraph("• 🐙 <b>Repository GitHub:</b> https://github.com/ifanagung3/201-AutoGarage", bullet_style))
    story.append(Paragraph("• 🎨 <b>Design Figma (UI/UX):</b> https://www.figma.com/file/201-AutoGarage-UI-Design", bullet_style))
    story.append(Paragraph("• 🛠️ <b>Teknologi Utama:</b> Flutter (Dart), Firebase Auth, Cloud Firestore", bullet_style))
    story.append(Spacer(1, 10))

    # Bab 1
    story.append(Paragraph("BAB I: PENDAHULUAN", h1_style))
    story.append(Paragraph("Perkembangan teknologi informasi dan perangkat bergerak (mobile devices) telah membawa dampak signifikan terhadap efisiensi operasional di berbagai industri, termasuk industri otomotif dan layanan perawatan kendaraan. Bengkel <b>201 Auto Garage</b> merupakan penyedia jasa perawatan kendaraan yang membutuhkan transformasi digital.", body_style))
    story.append(Paragraph("Permasalahan utama yang dihadapi pelanggan adalah antrean panjang di lokasi bengkel dan keterbatasan akses informasi mengenai jadwal ketersediaan pengerjaan. Oleh karena itu, dibangun aplikasi mobile berbasis Flutter dan Firebase yang memfasilitasi pemesanan servis terstruktur dan pelacakan status pengerjaan secara real-time.", body_style))
    story.append(Spacer(1, 10))

    # Bab 2
    story.append(Paragraph("BAB II: LANDASAN TEORI", h1_style))
    story.append(Paragraph("<b>1. Flutter Framework:</b> Framework open-source dari Google untuk membangun aplikasi cross-platform dari single codebase menggunakan bahasa Dart.", body_style))
    story.append(Paragraph("<b>2. Firebase Ecosystem:</b> Layanan BaaS menyediakan Firebase Authentication dan Cloud Firestore (database NoSQL real-time).", body_style))
    story.append(Paragraph("<b>3. GoRouter & PopScope:</b> Manajemen navigasi berantai dan penanganan tombol back fisik pada perangkat mobile.", body_style))
    story.append(Spacer(1, 10))

    # Bab 3 & Table Testing
    story.append(Paragraph("BAB III: HASIL PENGUJIANKINERJA SISTEM APLIKASI", h1_style))

    table_data = [
        ['No', 'Modul / Fitur', 'Skenario Pengujian', 'Status Pengujian'],
        ['1', 'Otentikasi', 'Login Email & Google Sign-In', 'PASSED'],
        ['2', 'Pemesanan', 'Booking Layanan → Tanggal → Waktu', 'PASSED'],
        ['3', 'Status Live', 'Update status pengerjaan via Firestore', 'PASSED'],
        ['4', 'Navigasi Back', 'Tombol back fisik via PopScope', 'PASSED'],
        ['5', 'Usability (SUS)', 'Pengujian Usability Pengguna', '84.5 (Grade A)']
    ]

    t = Table(table_data, colWidths=[30, 120, 230, 120])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#5B8DEF')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor('#CBD5E1')),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor('#F8FAFC')]),
        ('FONTSIZE', (0,0), (-1,-1), 9),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('TOPPADDING', (0,0), (-1,-1), 6),
    ]))
    story.append(t)
    story.append(Spacer(1, 15))

    # Bab 4
    story.append(Paragraph("BAB IV: KESIMPULAN", h1_style))
    story.append(Paragraph("1. Aplikasi Mobile 201 Auto Garage berhasil dibangun menggunakan Flutter dan Firebase dengan antarmuka yang modern, responsif, serta terbungkus PopScope.", body_style))
    story.append(Paragraph("2. Sistem pemesanan dan pelacakan status pengerjaan secara real-time berbasis Cloud Firestore memudahkan pelanggan melacak progres pengerjaan servis kendaraan.", body_style))
    story.append(Paragraph("3. Seluruh pengujian unit test dan integrasi sistem lulus 100%.", body_style))

    doc.build(story)
    print(f"✅ File PDF berhasil diperbarui: {pdf_path}")

if __name__ == '__main__':
    generate_pdf()
