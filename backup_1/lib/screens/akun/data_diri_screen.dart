import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Diri'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/akun'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)), enabled: false),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Nomor Telepon', prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Tanggal Lahir', prefixIcon: Icon(Icons.calendar_today))),
            const Spacer(),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => context.go('/akun'), child: const Text('Simpan'))),
          ],
        ),
      ),
    );
  }
}
