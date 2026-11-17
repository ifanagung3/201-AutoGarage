# Bagian III UTS SBDT - 201 Auto Garage

**Mahasiswa:** Ifan Agung Arisadi / 20230801162  
**Dosen:** Imam Sutanto, S.Kom, M.Kom  
**Mata kuliah:** Sistem Basis Data Terdistribusi, Ganjil 2026-2027

Modul ini menambahkan FastAPI, PostgreSQL primary/read-replica, Keycloak OIDC,
Docker Compose, StatefulSet/PVC, serta Ingress Kubernetes ke studi kasus 201 AutoGarage.
Dataset dan fitur Random Forest diadaptasi dari `python_backend/` pada commit
`60dd5336a2ad90443bad4a5f471de5ffb498da1d`. Aplikasi Flutter/Firebase asal tetap
tersedia pada repositori. Halaman `/demo` adalah klien web demonstrasi modul UTS,
bukan klaim bahwa Flutter asal telah dimigrasikan ke Keycloak.

## Arsitektur

```text
Klien web -- OIDC Authorization Code + PKCE --> Keycloak
Klien web -- JWT --> Ingress/Gateway --> FastAPI + Random Forest
FastAPI -- INSERT --> PostgreSQL primary -- streaming WAL --> replica
FastAPI -- SELECT riwayat pengguna --> PostgreSQL replica
Database pod -- volumeClaimTemplates --> PVC/PV tersendiri
```

API memeriksa peran server dengan `pg_is_in_recovery()` sebelum read/write.
POST hanya berhasil setelah commit. Riwayat dibatasi oleh `sub` token, bukan ID
pengguna pada payload. Token diverifikasi lokal dengan RSA/JWKS: signature,
issuer, audience, expiry, `nbf` bila ada, dan peran `autogarage_user`.
Replica asynchronous dapat mengalami jeda singkat; script uji menunggu replay.

## Docker lokal

Prasyarat: Docker Engine/Compose, Python 3.12, dan untuk pengujian browser Chromium Playwright.
Jalankan dari folder `uts-sbdt`:

```bash
python -m pip install -r backend/requirements-test.txt
python -m playwright install chromium
python scripts/bootstrap.py
# Tambahkan pada file hosts komputer:
# 127.0.0.1 auth.lokal api.lokal
docker compose up -d --build
python scripts/e2e.py compose
python scripts/browser-proof.py compose
```

Buka `http://api.lokal:8080/demo`, lalu klik Masuk melalui SSO. Akun lab:
`ifan`, dengan password pada `DEMO_PASSWORD` di `.env`. Akun `penguji` dipakai
untuk uji isolasi riwayat dan `tamu` untuk uji penolakan peran. Semua password
dibuat acak oleh bootstrap dan tidak disimpan ke Git. File realm yang dihasilkan
hanya untuk lab lokal; jangan membagikannya beserta `.env`.

Keycloak menyediakan dua jenis client terpisah: `autogarage-web` memakai Code +
PKCE tanpa direct grant, sedangkan `autogarage-ci` memakai direct grant hanya
untuk pengujian otomatis pada realm lab. Client `wrong-audience` membuktikan
penolakan audience. Endpoint `/pkce/challenge` menyediakan digest S256 stateless
untuk browser HTTP lokal yang tidak menyediakan WebCrypto.subtle. Gunakan HTTPS
untuk deployment di luar lab; jangan gunakan akun/konfigurasi lab untuk produksi.

## Kubernetes Kind

```bash
docker compose down
kind create cluster --name autogarage --image kindest/node:v1.32.2 --config kubernetes/kind.yaml
kind load docker-image autogarage-uts:e2e --name autogarage
python scripts/deploy-k8s.py
python scripts/e2e.py kubernetes
python scripts/browser-proof.py kubernetes
```

`deploy-k8s.py` ditujukan untuk namespace lab baru. Script membentuk Secret dari
file lokal (tanpa password di argumen command), ConfigMap skrip DB, StatefulSet,
PVC dinamis `standard`, Deployment, Service, dan Ingress Controller Traefik.
Kind memetakan port 8080 host ke NodePort 30080; URL klien sama dengan Compose.
Primary dan replica memakai volume berbeda. Penghapusan pod mempertahankan PVC.

Uji persistence mencatat UID pod dan PVC/PV sebelum serta sesudah penghapusan
pod primary. Uji kemudian memeriksa ID lama langsung pada primary dan memastikan
write baru berhasil direplikasi. Ini menguji restart/persistence, bukan promosi
standby atau failover otomatis. Kehilangan node/volume tunggal memerlukan strategi
storage dan backup tambahan, di luar cakupan demonstrasi ini.

## Pengujian dan bukti asli

```bash
pytest tests -v
```

Workflow `.github/workflows/python-app.yml` menjalankan unit test, membangun
image multi-stage, menguji Compose, membuka login SSO di Chromium, lalu membuat
cluster Kind dan menguji persistence. Artefak `autogarage-uts-evidence` memuat:

- hasil JSON pengujian HTTP/SQL dan observasi UID pod/PVC;
- output asli status layanan, log, dan versi Docker/Kubernetes;
- screenshot Chromium halaman login, login sukses, dan inferensi/riwayat;
- commit sumber, URL workflow, waktu UTC, dan ID image.

Token dan password tidak dimasukkan ke bukti. Jangan menyatakan suatu uji lulus
hanya karena konfigurasi tersedia; gunakan hasil workflow dan artefak aktualnya.

## Model

Terdapat dua RandomForestRegressor dengan 100 pohon dan seed 42 untuk biaya
serta durasi. Pelatihan memakai enam fitur dan 10 baris dataset proyek asal.
Evaluasi holdout memakai 8 baris latih / 2 baris uji dan dicatat dalam manifest;
model akhir dilatih pada seluruh dataset contoh. Dataset kecil ini membuktikan
alur inferensi, bukan kelayakan atau akurasi pemakaian bengkel nyata. Backend
tidak memakai rumus fallback ketika artefak hilang; prediksi ditolak dengan 503.

## Susunan berkas

- `backend/`: API, klien demo, lock dependensi, Dockerfile, training dan dataset.
- `database/`: migrasi SQL, inisialisasi role, bootstrap streaming replica.
- `gateway/`: reverse proxy Compose untuk `auth.lokal` dan `api.lokal`.
- `kubernetes/`: konfigurasi Kind, StatefulSet/PVC, Service, dan Ingress.
- `scripts/`: bootstrap, deployment, uji HTTP/SQL/persistence, screenshot browser.
- `tests/`: pemeriksaan keamanan JWT, validasi payload, model dan PKCE.
- `evidence/`: bukti hasil eksekusi, tidak dilacak Git.

Penghentian lab: `docker compose down` atau `kind delete cluster --name autogarage`.
`docker compose down -v` menghapus data lab; gunakan hanya bila memang ingin reset.

## Hasil pelaksanaan

Validasi lokal 17 November 2026: 18 unit test, 9 kelompok integrasi Compose,
11 kelompok integrasi Kubernetes, dan 2 alur browser lulus. Lihat
[rekaman hasil dan bukti asli](VALIDATION.md).

Pertahankan `.env` selama volume lab dipakai agar kredensial tetap sesuai.
Jika ingin reset penuh, hentikan layanan dan hapus volume lab secara sengaja
sebelum membuat kredensial baru.
