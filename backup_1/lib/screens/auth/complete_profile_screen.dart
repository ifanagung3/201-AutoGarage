import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lengkapi Profil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Nomor Telepon', prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Alamat', prefixIcon: Icon(Icons.location_on_outlined))),
            const Spacer(),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => context.go('/home'), child: const Text('Selesai'))),
          ],
        ),
      ),
    );
  }
}
