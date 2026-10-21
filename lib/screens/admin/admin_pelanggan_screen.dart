import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPelangganScreen extends StatefulWidget {
  const AdminPelangganScreen({super.key});

  @override
  State<AdminPelangganScreen> createState() => _AdminPelangganScreenState();
}

class _AdminPelangganScreenState extends State<AdminPelangganScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> pelanggan = [
    {'nama': 'Budi Santoso', 'email': 'budi@email.com', 'total': '3 booking'},
    {'nama': 'Siti Rahayu', 'email': 'siti@email.com', 'total': '1 booking'},
    {'nama': 'Andi Wijaya', 'email': 'andi@email.com', 'total': '5 booking'},
    {'nama': 'Dewi Putri', 'email': 'dewi@email.com', 'total': '2 booking'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = pelanggan
        .where((p) =>
            p['nama']!.toLowerCase().contains(_query.toLowerCase()) ||
            p['email']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text('Data Pelanggan',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
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
                hintText: 'Cari pelanggan...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A3C),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final p = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3C),
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFEA580C),
                        child: Text(p['nama']![0],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['nama']!,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text(p['email']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.grey[400])),
                            Text(p['total']!,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFFEA580C))),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
