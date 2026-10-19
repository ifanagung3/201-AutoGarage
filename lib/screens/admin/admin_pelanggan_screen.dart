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
      UserModel(uid: '3', name: 'Siti Rahayu', email: 'siti@email.com', phone: '081355554444', role: 'user', createdAt: DateTime.now()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        title: Text('Data Pelanggan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama / email pelanggan...',
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
                final filtered = users
                    .where((u) =>
                        u.name.toLowerCase().contains(_query.toLowerCase()) ||
                        u.email.toLowerCase().contains(_query.toLowerCase()))
                    .toList();

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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF2A2A3C), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFEA580C),
                            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(u.email, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
                                if (u.phone.isNotEmpty)
                                  Text('HP: ${u.phone}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFEA580C))),
                              ],
                            ),
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
