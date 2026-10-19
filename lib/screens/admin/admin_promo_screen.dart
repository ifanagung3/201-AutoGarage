import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      if (snapshot.docs.isEmpty) {
        return _getMockPromos();
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    }).handleError((_) => _getMockPromos());
  }

  List<Map<String, dynamic>> _getMockPromos() {
    return [
      {'id': 'p1', 'title': 'Diskon 20% Servis Rutin', 'code': 'SERVIS20', 'discount': '20%', 'isActive': true},
      {'id': 'p2', 'title': 'Gratis Cuci Mobil', 'code': 'CUCIGRATIS', 'discount': '100%', 'isActive': false},
      {'id': 'p3', 'title': 'Diskon 10% Tune Up', 'code': 'TUNEUP10', 'discount': '10%', 'isActive': true},
    ];
  }

  void _showAddPromoDialog() {
    final titleController = TextEditingController();
    final codeController = TextEditingController();
    final discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3C),
        title: Text('Tambah Promo Baru', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Judul Promo', labelStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: codeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Kode Promo', labelStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: discountController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Besar Diskon (%)', labelStyle: TextStyle(color: Colors.grey)),
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
              if (titleController.text.isNotEmpty && codeController.text.isNotEmpty) {
                try {
                  await _db.collection('promos').add({
                    'title': titleController.text.trim(),
                    'code': codeController.text.trim().toUpperCase(),
                    'discount': '${discountController.text.trim()}%',
                    'isActive': true,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                } catch (_) {}
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C)),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text('Kelola Promo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _streamPromos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)));
          }

          final promos = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              final bool isActive = promo['isActive'] ?? true;
              final String id = promo['id'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF2A2A3C), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(promo['title'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Kode: ${promo['code'] ?? ''}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
                          Text('Diskon: ${promo['discount'] ?? ''}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFEA580C))),
                        ],
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeTrackColor: const Color(0xFFEA580C),
                      onChanged: (val) async {
                        if (id.isNotEmpty) {
                          try {
                            await _db.collection('promos').doc(id).update({'isActive': val});
                          } catch (_) {}
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
        onPressed: _showAddPromoDialog,
        backgroundColor: const Color(0xFFEA580C),
        child: const Icon(Icons.add),
      ),
    );
  }
}
