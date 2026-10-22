import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class AdminEstimasiScreen extends StatelessWidget {
  const AdminEstimasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Text('Input Estimasi Biaya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingService.instance.streamAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF97316)));
          }

          final bookings = snapshot.data ?? [];
          final activeBookings = bookings.where((b) => b.status != 'Selesai' && b.status != 'Dibatalkan').toList();

          if (activeBookings.isEmpty) {
            return Center(
              child: Text('Tidak ada booking aktif untuk estimasi', style: GoogleFonts.poppins(color: Colors.grey[400])),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: activeBookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = activeBookings[index];
              return _EstimasiCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _EstimasiCard extends StatelessWidget {
  final BookingModel booking;
  const _EstimasiCard({required this.booking});

  void _showEstimasiSheet(BuildContext context) {
    final controller = TextEditingController(text: booking.estimatedCost.round().toString());
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Estimasi Biaya (${booking.id})', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text('Layanan: ${booking.serviceName} • Kendaraan: ${booking.vehicleName}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Estimasi Biaya Baru (Rp)',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final newCost = double.tryParse(controller.text.trim());
                  if (newCost != null && newCost > 0) {
                    try {
                      await FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
                        'estimatedCost': newCost,
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Estimasi biaya ${booking.id} diupdate ke ${currencyFormat.format(newCost)}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(ctx);
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal update: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
                child: Text('Simpan Estimasi Ke Firestore', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final displayId = booking.id.length > 10 ? '#${booking.id.substring(0, 8)}...' : booking.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(displayId, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
              ),
              const SizedBox(width: 8),
              Text(currencyFormat.format(booking.estimatedCost), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFFF97316))),
            ],
          ),
          const SizedBox(height: 4),
          Text('${booking.serviceName} - ${booking.vehicleName} (${booking.vehiclePlat})', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showEstimasiSheet(context),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Edit Estimasi Biaya'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            ),
          ),
        ],
      ),
    );
  }
}
