import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AlamatSayaScreen extends StatelessWidget {
  const AlamatSayaScreen({super.key});

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
          title: const Text('Alamat Saya'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBack(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _AddressCard(
                label: 'Rumah',
                address: 'Jl. Raya Jakarta No. 123, Jakarta Barat'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFF3B45),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String label, address;
  const _AddressCard({required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
            backgroundColor: Color(0xFFFF3B45),
            child: Icon(Icons.location_on, color: Colors.white)),
        title: Text(label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(address, style: GoogleFonts.poppins(fontSize: 12)),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
      ),
    );
  }
}
