import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AdminPelangganScreen extends StatefulWidget {
  const AdminPelangganScreen({super.key});

  @override
  State<AdminPelangganScreen> createState() => _AdminPelangganScreenState();
}

class _AdminPelangganScreenState extends State<AdminPelangganScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  Stream<List<UserModel>> _streamUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _getMockUsers();
      }
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc.data(), doc.id)).toList();
    }).handleError((_) => _getMockUsers());
  }

  List<UserModel> _getMockUsers() {
    return [
      UserModel(uid: '1', name: 'Ahmad Fauzi', email: 'ahmad@email.com', phone: '081234567890', role: 'user', createdAt: DateTime.now()),
      UserModel(uid: '2', name: 'Budi Santoso', email: 'budi@email.com', phone: '081298765432', role: 'user', createdAt: DateTime.now()),
      UserModel(uid: '3', name: 'Admin Bengkel', email: 'admin@autogarage.com', phone: '081355554444', role: 'admin', createdAt: DateTime.now()),
    ];
  }

  void _confirmToggleRole(BuildContext context, UserModel user) {
    final newRole = user.role == 'admin' ? 'user' : 'admin';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3C),
        title: Text('Ubah Role Pengguna?', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Ubah role ${user.name} (${user.email}) dari "${user.role.toUpperCase()}" menjadi "${newRole.toUpperCase()}"?',
          style: GoogleFonts.poppins(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                  'role': newRole,
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Role ${user.name} berhasil diubah ke ${newRole.toUpperCase()}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengubah role: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C)),
            child: const Text('Ya, Ubah Role'),
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
        title: Text('Data Pelanggan & User Sync', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama, email, atau HP pelanggan...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A3C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _streamUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFEA580C)));
                }

                final users = snapshot.data ?? [];
                final filtered = users.where((u) {
                  final q = _query.toLowerCase();
                  return u.name.toLowerCase().contains(q) ||
                      u.email.toLowerCase().contains(q) ||
                      u.phone.toLowerCase().contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('Pelanggan tidak ditemukan', style: GoogleFonts.poppins(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final u = filtered[index];
                    final initial = u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U';
                    final isAdmin = u.role == 'admin';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF2A2A3C), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: isAdmin ? Colors.purple : const Color(0xFFEA580C),
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        u.name,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isAdmin ? Colors.purple.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        u.role.toUpperCase(),
                                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: isAdmin ? Colors.purpleAccent : Colors.lightBlueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(u.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
                                if (u.phone.isNotEmpty)
                                  Text('HP: ${u.phone}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFEA580C))),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.manage_accounts, color: Colors.grey),
                            tooltip: 'Ubah Role',
                            onPressed: () => _confirmToggleRole(context, u),
                          ),
                        ],
                      ),
                    );
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
