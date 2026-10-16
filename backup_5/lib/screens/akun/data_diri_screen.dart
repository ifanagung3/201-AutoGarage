import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DataDiriScreen extends StatelessWidget {
  const DataDiriScreen({super.key});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/akun');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Data Diri'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBack(context),
          ),
        ),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleBack(context),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
