import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPromoScreen extends StatefulWidget {
  const AdminPromoScreen({super.key});

  @override
  State<AdminPromoScreen> createState() => _AdminPromoScreenState();
}

class _AdminPromoScreenState extends State<AdminPromoScreen> {
  final List<Map<String, dynamic>> promos = [
    {'title': 'Diskon 20% Servis Rutin', 'code': 'SERVIS20', 'discount': '20%', 'isActive': true},
    {'title': 'Gratis Cuci Mobil', 'code': 'CUCIGRATIS', 'discount': '0%', 'isActive': false},
    {'title': 'Diskon 10% Tune Up', 'code': 'TUNEUP10', 'discount': '10%', 'isActive': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text('Kelola Promo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final promo = promos[index];
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
                      Text(promo['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Kode: ${promo['code']}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
                      Text('Diskon: ${promo['discount']}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFEA580C))),
                    ],
                  ),
                ),
                Switch(
                  value: promo['isActive'],
                  onChanged: (val) => setState(() => promos[index]['isActive'] = val),
                  activeColor: const Color(0xFFEA580C),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFEA580C),
        child: const Icon(Icons.add),
      ),
    );
  }
}
