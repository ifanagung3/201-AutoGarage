import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminServisScreen extends StatelessWidget {
  const AdminServisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text('Update Servis', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) => _ServisCard(index: index),
      ),
    );
  }
}

class _ServisCard extends StatefulWidget {
  final int index;
  const _ServisCard({required this.index});

  @override
  State<_ServisCard> createState() => _ServisCardState();
}

class _ServisCardState extends State<_ServisCard> {
  int _currentStep = 0;
  final List<String> steps = ['Penerimaan Kendaraan', 'Diagnosa', 'Pengerjaan', 'Quality Check', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2A2A3C), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking #00${widget.index + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          Text('Servis Rutin - Toyota Avanza', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_currentStep + 1) / steps.length,
            backgroundColor: Colors.grey[700],
            color: const Color(0xFFEA580C),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text('${steps[_currentStep]} (${_currentStep + 1}/${steps.length})', style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFEA580C))),
          const SizedBox(height: 12),
          Row(
            children: [
              if (_currentStep < steps.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentStep++),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C)),
                    child: const Text('Lanjut Tahap'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
