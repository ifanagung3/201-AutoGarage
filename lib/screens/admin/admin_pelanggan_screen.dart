import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_colors.dart';

class AdminPelangganScreen extends StatefulWidget {
  const AdminPelangganScreen({super.key, this.customersStream});

  final Stream<List<Map<String, dynamic>>>? customersStream;

  @override
  State<AdminPelangganScreen> createState() => _AdminPelangganScreenState();
}

class _AdminPelangganScreenState extends State<AdminPelangganScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late Stream<List<Map<String, dynamic>>> _customers;

  @override
  void initState() {
    super.initState();
    _customers = _streamPelanggan();
  }

  Stream<List<Map<String, dynamic>>> _streamPelanggan() {
    return widget.customersStream ??
        FirebaseFirestore.instance
            .collection('users')
            .where('role', whereIn: ['user', 'customer'])
            .snapshots()
            .map((snapshot) {
              return snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: Text('Data Pelanggan',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari nama pelanggan, email, atau nomor HP...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _customers,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  final denied = error is FirebaseException &&
                      error.code == 'permission-denied';
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        denied
                            ? 'Akses pelanggan ditolak. Periksa role admin dan Firestore Rules.'
                            : 'Gagal menyinkronkan pelanggan. Periksa koneksi internet.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      TextButton(
                        onPressed: () =>
                            setState(() => _customers = _streamPelanggan()),
                        child: const Text('Coba lagi'),
                      ),
                    ]),
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF3B45)));
                }

                final allPelanggan = snapshot.data ?? [];
                final filtered = allPelanggan.where((p) {
                  final q = _searchQuery.trim().toLowerCase();
                  return (p['name'] ?? '').toLowerCase().contains(q) ||
                      (p['email'] ?? '').toLowerCase().contains(q) ||
                      (p['phone'] ?? '').toLowerCase().contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                        allPelanggan.isEmpty
                            ? 'Belum ada pelanggan terdaftar di database'
                            : 'Pelanggan tidak ditemukan',
                        style: GoogleFonts.poppins(color: AppColors.textMuted)),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final pelanggan = filtered[index];
                    return _PelangganCard(pelanggan: pelanggan);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _PelangganCard extends StatelessWidget {
  final Map<String, dynamic> pelanggan;
  const _PelangganCard({required this.pelanggan});

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(pelanggan['name'] ?? 'Pelanggan',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow('Email', pelanggan['email'] ?? '-'),
              _InfoRow('Nomor HP', pelanggan['phone'] ?? '-'),
              _InfoRow('Alamat', pelanggan['address'] ?? '-'),
              _InfoRow(
                  'Tanggal Daftar',
                  pelanggan['createdAt']?.toDate()?.toString().split(' ')[0] ??
                      '-'),
              _InfoRow('Total Booking',
                  (pelanggan['totalBookings'] ?? 0).toString()),
              _InfoRow('Status',
                  pelanggan['isActive'] ?? true ? 'Aktif' : 'Tidak Aktif',
                  isStatus: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Tutup', style: TextStyle(color: Color(0xFFFF3B45))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B45).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (pelanggan['name'] as String? ?? '').trim().isEmpty
                    ? 'P'
                    : (pelanggan['name'] as String).trim()[0].toUpperCase(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF3B45),
                    fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pelanggan['name'] ?? 'Pelanggan',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(pelanggan['email'] ?? '-',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(pelanggan['phone'] ?? '-',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: Color(0xFFFF3B45)),
            onPressed: () => _showDetailDialog(context),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool isStatus;
  const _InfoRow(this.label, this.value, {this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: value == 'Aktif'
                          ? const Color(0xFF10B981).withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(value,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: value == 'Aktif'
                                ? const Color(0xFF10B981)
                                : Colors.red,
                            fontWeight: FontWeight.bold)),
                  )
                : Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
