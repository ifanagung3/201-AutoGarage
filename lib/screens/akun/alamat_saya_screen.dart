import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AddressItem {
  String label;
  String fullAddress;

  AddressItem({required this.label, required this.fullAddress});
}

class AlamatSayaScreen extends StatefulWidget {
  const AlamatSayaScreen({super.key});

  @override
  State<AlamatSayaScreen> createState() => _AlamatSayaScreenState();
}

class _AlamatSayaScreenState extends State<AlamatSayaScreen> {
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  final List<AddressItem> _addresses = [
    AddressItem(label: 'Rumah Utama', fullAddress: 'Jl. Merdeka No. 45, RT 02/RW 05, Bandung'),
    AddressItem(label: 'Kantor', fullAddress: 'Jl. Sudirman Kav. 10-11, Jakarta Selatan'),
  ];

  void _showAddAddressDialog() {
    final labelController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Alamat Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelController, decoration: const InputDecoration(labelText: 'Label (Contoh: Rumah / Kos / Kantor)')),
            const SizedBox(height: 10),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Alamat Lengkap')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (labelController.text.isNotEmpty && addressController.text.isNotEmpty) {
                setState(() {
                  _addresses.add(AddressItem(label: labelController.text, fullAddress: addressController.text));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alamat berhasil ditambahkan!'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Alamat Saya',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final addr = _addresses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: primaryColor, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addr.label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimary)),
                      const SizedBox(height: 2),
                      Text(addr.fullAddress, style: GoogleFonts.poppins(fontSize: 13, color: textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () {
                    setState(() => _addresses.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alamat dihapus'), behavior: SnackBarBehavior.floating),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAddressDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Alamat', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
