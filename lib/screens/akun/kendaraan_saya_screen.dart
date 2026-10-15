import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class KendaraanSayaScreen extends StatelessWidget {
  const KendaraanSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kendaraan Saya'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/akun'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _VehicleCard(merk: 'Toyota Avanza', plat: 'B 1234 XYZ', tahun: '2020'),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add), backgroundColor: const Color(0xFF3B82F6)),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String merk, plat, tahun;
  const _VehicleCard({required this.merk, required this.plat, required this.tahun});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Icon(Icons.directions_car, color: Colors.white)),
        title: Text(merk, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text('$plat • $tahun', style: GoogleFonts.poppins(fontSize: 12)),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
      ),
    );
  }
}
