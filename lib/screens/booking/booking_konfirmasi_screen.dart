import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/booking_service.dart';
import '../../services/random_forest_service.dart';
import '../../models/booking_draft.dart';

class BookingKonfirmasiScreen extends StatefulWidget {
  const BookingKonfirmasiScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingKonfirmasiScreen> createState() =>
      _BookingKonfirmasiScreenState();
}

class _BookingKonfirmasiScreenState extends State<BookingKonfirmasiScreen> {
  final _notesController = TextEditingController();
  final _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  bool _isLoading = false;
  bool _isPredicting = true;

  double _estimatedCost = 1150000;
  double _estimatedDurationHours = 3.8;
  String _recommendation =
      "Disarankan melakukan pemeriksaan filter udara & ganti oli";

  @override
  void initState() {
    super.initState();
    _fetchMlPrediction();
  }

  Future<void> _fetchMlPrediction() async {
    setState(() => _isPredicting = true);
    final result = await RandomForestService.instance.predictViaApi(
      carBrand: 'Toyota',
      carModel: 'Avanza',
      carYear: 2018,
      serviceType: widget.draft.serviceName ?? 'Servis Rutin',
      mileage: 75000,
      componentCount: 5,
    );

    if (mounted) {
      setState(() {
        _estimatedCost = result.estimatedCost;
        _estimatedDurationHours = result.estimatedDuration;
        _recommendation = result.recommendation;
        _isPredicting = false;
      });
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/booking/waktu', extra: widget.draft);
    }
  }

  Future<void> _submitBooking() async {
    setState(() => _isLoading = true);
    try {
      await BookingService.instance.createBooking(
        vehicleName: 'Toyota Avanza 1.3 G',
        vehiclePlat: 'B 1234 AG',
        vehicleYear: 2018,
        vehicleKm: 75000,
        serviceName: widget.draft.serviceName!,
        bookingDate: widget.draft.bookingDate!,
        bookingTime: '${widget.draft.bookingTime} WIB',
        estimatedCost: _estimatedCost,
        notes: _notesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking berhasil disimpan!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/status');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5B8DEF),
          elevation: 0,
          title: Text(
            'Konfirmasi Booking',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ML Prediction Banner Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF5B8DEF).withOpacity(0.3),
                          width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5B8DEF).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome,
                                  color: Color(0xFF5B8DEF), size: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Estimasi AI (Random Forest Regression)',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        if (_isPredicting)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Color(0xFF5B8DEF), strokeWidth: 2),
                              ),
                            ),
                          )
                        else ...[
                          _DetailRow(
                            label: 'Estimasi Biaya',
                            value: _currencyFormat.format(_estimatedCost),
                            isHighlight: true,
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Estimasi Waktu',
                            value:
                                '3-4 jam (${_estimatedDurationHours.toStringAsFixed(1)} jam)',
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Rekomendasi AI',
                            value: _recommendation,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Detail Booking Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Jadwal & Kendaraan',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                            label: 'Layanan',
                            value: widget.draft.serviceName ?? '-'),
                        const SizedBox(height: 10),
                        const _DetailRow(
                            label: 'Kendaraan',
                            value: 'Toyota Avanza 1.3 G (2018)'),
                        const SizedBox(height: 10),
                        const _DetailRow(
                            label: 'Jarak Tempuh', value: '75.000 KM'),
                        const SizedBox(height: 10),
                        _DetailRow(
                          label: 'Tanggal',
                          value: widget.draft.bookingDate == null
                              ? '-'
                              : DateFormat('d MMMM y', 'id_ID')
                                  .format(widget.draft.bookingDate!),
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          label: 'Waktu',
                          value: widget.draft.bookingTime == null
                              ? '-'
                              : '${widget.draft.bookingTime} WIB',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes Input Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan Keluhan (Opsional)',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          style: GoogleFonts.poppins(fontSize: 13),
                          decoration: InputDecoration(
                            hintText:
                                'Contoh: Suara mesin agak kasar saat RPM rendah',
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[400], fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Submit Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading || !widget.draft.isComplete
                      ? null
                      : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B8DEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Konfirmasi Booking',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: isHighlight ? 15 : 13,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color: isHighlight
                  ? const Color(0xFF5B8DEF)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
