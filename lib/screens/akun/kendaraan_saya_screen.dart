import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class Vehicle {
  String brand;
  String model;
  String licensePlate;
  String year;

  Vehicle({required this.brand, required this.model, required this.licensePlate, required this.year});
}

class KendaraanSayaScreen extends StatefulWidget {
  const KendaraanSayaScreen({super.key});

  @override
  State<KendaraanSayaScreen> createState() => _KendaraanSayaScreenState();
}

class _KendaraanSayaScreenState extends State<KendaraanSayaScreen> {
  static const Color bgColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  final List<Vehicle> _vehicles = [
    Vehicle(brand: 'Toyota', model: 'Avanza Veloz', licensePlate: 'B 1234 XYZ', year: '2022'),
    Vehicle(brand: 'Honda', model: 'Civic Turbo', licensePlate: 'B 8888 ABC', year: '2023'),
  ];

  void _showAddVehicleDialog() {
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final plateController = TextEditingController();
    final yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Kendaraan Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Merek (Contoh: Toyota)')),
              const SizedBox(height: 10),
              TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Model (Contoh: Innova)')),
              const SizedBox(height: 10),
              TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Nomor Plat (Contoh: B 1234 CD)')),
              const SizedBox(height: 10),
              TextField(controller: yearController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Tahun (Contoh: 2021)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (brandController.text.isNotEmpty && plateController.text.isNotEmpty) {
                setState(() {
                  _vehicles.add(Vehicle(
                    brand: brandController.text,
                    model: modelController.text,
                    licensePlate: plateController.text,
                    year: yearController.text,
                  ));
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kendaraan berhasil ditambahkan!'), behavior: SnackBarBehavior.floating),
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
          'Kendaraan Saya',
          style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final v = _vehicles[index];
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.directions_car_rounded, color: primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${v.brand} ${v.model}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                      const SizedBox(height: 2),
                      Text('Plat: ${v.licensePlate} (${v.year})', style: GoogleFonts.poppins(fontSize: 13, color: textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: () {
                    setState(() => _vehicles.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kendaraan dihapus'), behavior: SnackBarBehavior.floating),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVehicleDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah Kendaraan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
