# ABSTRAK

**Judul:** Rancang Bangun Aplikasi Mobile Booking Servis Mobil Berbasis Flutter dan Firebase dengan Integrasi Random Forest untuk Prediksi Estimasi Biaya dan Waktu Pengerjaan

---

## Abstrak Bahasa Indonesia

Perkembangan teknologi informasi telah mengubah cara pelanggan mengakses layanan servis kendaraan. Namun, ketidakpastian biaya dan durasi waktu servis seringkali menjadi kendala utama yang menyebabkan keraguan pelanggan dalam melakukan pemesanan layanan. Penelitian ini bertujuan untuk merancang dan membangun aplikasi mobile pemesanan servis kendaraan pada 201 Auto Garage yang terintegrasi dengan algoritma Random Forest Regression untuk memprediksi estimasi biaya dan waktu pengerjaan secara akurat.

Sistem dikembangkan menggunakan framework Flutter untuk antarmuka aplikasi mobile lintas platform (Android dan iOS), Firebase Authentication untuk keamanan akses pengguna, serta Firebase Firestore untuk penyimpanan data pemesanan secara real-time. Model Machine Learning dikembangkan menggunakan bahasa pemrograman Python dengan pustaka scikit-learn menggunakan algoritma Random Forest Regression yang dilatih dengan parameter masukan meliputi *car_brand*, *car_model*, *car_year*, *service_type*, *mileage*, dan *component_count*. Model ini diakses oleh aplikasi Flutter melalui REST API berbasis Flask/FastAPI.

Hasil pengujian menunjukkan bahwa model Random Forest mampu memprediksi estimasi biaya dan waktu pengerjaan dengan akurasi tinggi, dengan nilai Mean Absolute Percentage Error (MAPE) sebesar X%, R-squared ($R^2$) sebesar Y, dan Root Mean Squared Error (RMSE) sebesar Rp Z. Fitur-fitur utama aplikasi meliputi autentikasi multi-platform (email, Google, Facebook), pemesanan servis dengan estimasi biaya/waktu, pelacakan status servis real-time (*Menunggu*, *Proses Pengecekan*, *Sedang Dikerjakan*, *Quality Check*, *Selesai*), riwayat transaksi, serta dashboard manajemen admin.

Pengujian usability menggunakan metode System Usability Scale (SUS) menghasilkan skor rata-rata sebesar X, yang mengindikasikan tingkat penerimaan pengguna yang sangat baik. Aplikasi ini memberikan kontribusi signifikan dalam meningkatkan transparansi estimasi pengerjaan, kepercayaan pelanggan, serta efisiensi operasional bengkel 201 Auto Garage.

**Kata Kunci:** Aplikasi Mobile, Booking Servis, Flutter, Firebase, Random Forest Regression, Prediksi Biaya, Estimasi Durasi, 201 Auto Garage.

---

## Abstract (English)

The rapid development of information technology has transformed how customers access vehicle servicing facilities. However, uncertainty regarding service cost and duration often poses a major obstacle that causes customer hesitation in booking services. This study aims to design and develop a mobile vehicle service booking application for 201 Auto Garage integrated with the Random Forest Regression algorithm to accurately predict estimated cost and processing time.

The system is developed using the Flutter framework for cross-platform mobile application interfaces (Android and iOS), Firebase Authentication for secure user access, and Firebase Firestore for real-time booking data storage. The Machine Learning model is implemented using Python with scikit-learn library utilizing the Random Forest Regression algorithm trained on input parameters including *car_brand*, *car_model*, *car_year*, *service_type*, *mileage*, and *component_count*. The model is accessed by the Flutter application via a Flask/FastAPI REST API.

Testing results demonstrate that the Random Forest model is capable of predicting estimated costs and processing duration with high accuracy, achieving a Mean Absolute Percentage Error (MAPE) of X%, R-squared ($R^2$) of Y, and Root Mean Squared Error (RMSE) of Rp Z. Primary features include multi-platform authentication (email, Google, Facebook), service booking with cost/duration estimates, real-time service status tracking (*Pending*, *Inspection*, *In-Progress*, *Quality Check*, *Completed*), transaction history, and an admin management dashboard.

Usability testing using the System Usability Scale (SUS) method yielded an average score of X, indicating excellent user acceptance. This application contributes significantly to improving cost transparency, customer trust, and operational efficiency at 201 Auto Garage.

**Keywords:** Mobile Application, Service Booking, Flutter, Firebase, Random Forest Regression, Cost Prediction, Duration Estimation, 201 Auto Garage.
