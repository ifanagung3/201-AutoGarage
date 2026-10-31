import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPromoScreen extends StatefulWidget {
  const AdminPromoScreen({super.key});

  @override
  State<AdminPromoScreen> createState() => _AdminPromoScreenState();
}

class _AdminPromoScreenState extends State<AdminPromoScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> _streamPromos() {
    return _db.collection('promos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  void _showFirebaseError(String action, Object error) {
    if (!mounted) return;
    final detail = error is FirebaseException ? error.code : error.toString();
    debugPrint('Promo $action failed: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal $action ($detail). Coba lagi.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showPromoDialog({Map<String, dynamic>? promo}) {
    final isEditing = promo != null;
    final titleController = TextEditingController(text: promo?['title'] ?? '');
    final codeController = TextEditingController(text: promo?['code'] ?? '');
    final discountController = TextEditingController(
      text: (promo?['discount'] ?? '').toString().replaceAll('%', ''),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(
          isEditing ? 'Edit Promo' : 'Tambah Promo Baru',
          style: GoogleFonts.poppins(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                  labelText: 'Judul Promo',
                  labelStyle: TextStyle(color: AppColors.textMuted)),
            ),
            TextField(
              controller: codeController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                  labelText: 'Kode Promo',
                  labelStyle: TextStyle(color: AppColors.textMuted)),
            ),
            TextField(
              controller: discountController,
              style: const TextStyle(color: AppColors.textPrimary),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Besar Diskon (%)',
                  labelStyle: TextStyle(color: AppColors.textMuted)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  codeController.text.isNotEmpty) {
                try {
                  final data = {
                    'title': titleController.text.trim(),
                    'code': codeController.text.trim().toUpperCase(),
                    'discount': '${discountController.text.trim()}%',
                    'isActive': promo?['isActive'] ?? true,
                    'updatedAt': FieldValue.serverTimestamp(),
                  };

                  if (isEditing && promo['id'] != null) {
                    await _db
                        .collection('promos')
                        .doc(promo['id'])
                        .update(data);
                  } else {
                    data['createdAt'] = FieldValue.serverTimestamp();
                    await _db.collection('promos').add(data);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (error) {
                  _showFirebaseError('menyimpan promo', error);
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B45)),
            child: Text(isEditing ? 'Simpan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePromo(String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text('Hapus Promo?',
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus "$title"?',
            style: GoogleFonts.poppins(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _db.collection('promos').doc(id).delete();
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (error) {
                _showFirebaseError('menghapus promo', error);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: Text('Kelola Promo',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamPromos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF3B45)));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat promo dari Firebase. '
                      '${snapshot.error is FirebaseException ? (snapshot.error as FirebaseException).code : snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final promos = snapshot.data ?? [];
          if (promos.isEmpty) {
            return Center(
              child: Text(
                'Belum ada promo. Tambahkan promo baru.',
                style: GoogleFonts.poppins(color: AppColors.textMuted),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: promos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final promo = promos[index];
              final bool isActive = promo['isActive'] ?? true;
              final String id = promo['id'] ?? '';

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(promo['title'] ?? '',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('Kode: ${promo['code'] ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.textMuted)),
                          Text('Diskon: ${promo['discount'] ?? ''}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF3B45))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Color(0xFFFF3B45), size: 20),
                      onPressed: () => _showPromoDialog(promo: promo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () =>
                          _confirmDeletePromo(id, promo['title'] ?? 'Promo'),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: const Color(0xFFFF3B45),
                      onChanged: (val) async {
                        if (id.isNotEmpty) {
                          try {
                            await _db
                                .collection('promos')
                                .doc(id)
                                .update({'isActive': val});
                          } catch (error) {
                            _showFirebaseError('mengubah status promo', error);
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPromoDialog(),
        backgroundColor: const Color(0xFFFF3B45),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
