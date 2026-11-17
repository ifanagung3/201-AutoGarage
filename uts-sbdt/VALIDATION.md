# Hasil Validasi Bagian III - 201 Auto Garage

Pengujian nyata dilakukan pada VM Linux Ubuntu 24.04 ARM64 lokal, Docker Compose,
dan Kubernetes Kind v1.32.2. Commit implementasi yang diuji: `3d3154aa69e89c3de7a9880b0cede128e54d09a6`.
Kubernetes selesai pada 2026-11-17T16:11:52.239755+07:00. Semua berkas pada folder `validation-evidence/`
merupakan hasil eksekusi atau screenshot browser; `FILE_MANIFEST.json` mencatat
SHA-256 untuk pemeriksaan integritas.

| Lingkup | Hasil |
| --- | --- |
| Unit test | 18 passed, 0 failed, 0 errors |
| Integrasi Docker Compose | 9 kelompok pemeriksaan lulus |
| Integrasi Kubernetes | 11 kelompok pemeriksaan lulus |
| Browser OIDC Code + PKCE | 2 alur lulus, Compose dan Kubernetes |

Pengujian meliputi token sah dan tidak sah, audience, peran, payload, pemalsuan
pemilik data, inferensi, commit primary, pembacaan replica, isolasi riwayat,
verifikasi SQL, dan penolakan write pada standby. Pada browser, ID hasil yang
baru disimpan harus terlihat pada riwayat sebelum screenshot diambil.

## Persistence setelah hapus pod primary

- UID pod sebelum: `a9b5c83f-3ec6-47b8-96be-0a87ddef7895`.
- UID pod sesudah: `92592c13-b2a9-49a2-a475-548627ec8e32`.
- UID PVC tetap: `f5cbb5d6-1465-4090-87b7-6757806655e7`.
- PV tetap: `pvc-f5cbb5d6-1465-4090-87b7-6757806655e7`.
- Record lama tetap ada pada primary; write baru berhasil direplikasi.

Ini merupakan pembuktian restart/persistence; promosi standby dan failover
otomatis tidak diklaim. Model `autogarage-rf-v1-7bfb605fb173` memakai 10 baris dataset
contoh. Nilai evaluasi tersimpan pada manifest; dataset belum cukup untuk
menyatakan akurasi pemakaian bengkel nyata.

## Bukti asli

- [Hasil integrasi Compose](validation-evidence/compose-results.json).
- [Hasil integrasi Kubernetes dan UID/PVC](validation-evidence/kubernetes-results.json).
- [Hasil unit test](validation-evidence/local-unit-tests.txt).
- [Login Keycloak](validation-evidence/kubernetes-sso-login.png).
- [Inferensi dan riwayat](validation-evidence/kubernetes-inference-history.png).
- [Manifest model](validation-evidence/model-manifest.json).

Workflow GitHub Actions tersedia untuk menjalankan ulang pengujian. Hasil yang
tercatat di sini berasal dari eksekusi lokal; keberhasilan workflow tidak diklaim.
Kredensial, access token lengkap, dan kode otorisasi tidak disertakan.
