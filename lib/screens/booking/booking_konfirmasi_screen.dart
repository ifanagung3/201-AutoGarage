import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../services/booking_service.dart';
import '../../services/random_forest_service.dart';
import '../../models/booking_draft.dart';
import '../../models/garage_service.dart';

class BookingKonfirmasiScreen extends StatefulWidget {
  const BookingKonfirmasiScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingKonfirmasiScreen> createState() =>
      _BookingKonfirmasiScreenState();
}

class _BookingKonfirmasiScreenState extends State<BookingKonfirmasiScreen> {
  final _notesController = TextEditingController();

  bool _isLoading = false;
  bool _isPredicting = true;
  bool _hasAiEstimate = false;

  double _estimatedDurationHours = 3.8;
  String _recommendation = '';

  GarageService? get _service =>
      GarageServiceCatalog.findByName(widget.draft.serviceName);

  @override
  void initState() {
    super.initState();
    _fetchMlPrediction();
  }

  Future<void> _fetchMlPrediction() async {
    final service = _service;
    final vehicle = widget.draft.vehicle;
    if (service?.estimationCategory == null || vehicle == null) {
      setState(() {
        _isPredicting = false;
        _hasAiEstimate = false;
      });
      return;
    }

    setState(() => _isPredicting = true);
    final result = await RandomForestService.instance.predictViaApi(
      carBrand: vehicle.brand,
      carModel: vehicle.model,
      carYear: vehicle.year,
      serviceType: service!.estimationCategory!,
      mileage: vehicle.kilometer,
      componentCount: 5,
    );

    if (mounted) {
      setState(() {
        _estimatedDurationHours = result.estimatedDuration;
        _recommendation = result.recommendation;
        _isPredicting = false;
        _hasAiEstimate = true;
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
    final service = _service;
    final vehicle = widget.draft.vehicle;
    if (service == null || vehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih layanan dan kendaraan terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await BookingService.instance.createBooking(
        vehicleName: '${vehicle.brand} ${vehicle.model}',
        vehiclePlat: vehicle.platNumber,
        vehicleYear: vehicle.year,
        vehicleKm: vehicle.kilometer,
        serviceName: widget.draft.serviceName!,
        serviceOption: widget.draft.serviceOption,
        bookingDate: widget.draft.bookingDate!,
        bookingTime: '${widget.draft.bookingTime} WIB',
        estimatedCost: service.basePrice.toDouble(),
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
        context.go('/booking/sukses', extra: widget.draft);
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
    final service = _service;
    final vehicle = widget.draft.vehicle;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.softBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'Konfirmasi Booking',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Catalog price and optional AI duration estimate.
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFFF3B45).withValues(alpha: 0.3),
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
                                color: const Color(0xFFFF3B45)
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome,
                                  color: Color(0xFFFF3B45), size: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Harga & estimasi layanan',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                          label: 'Harga katalog',
                          value: service?.priceLabel ?? 'Layanan belum dipilih',
                          isHighlight: true,
                        ),
                        if (service?.priceNote != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            service!.priceNote!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                        const Divider(height: 20),
                        if (_isPredicting)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Color(0xFFFF3B45), strokeWidth: 2),
                              ),
                            ),
                          )
                        else if (_hasAiEstimate) ...[
                          _DetailRow(
                            label: 'Perkiraan waktu (AI)',
                            value:
                                '${_estimatedDurationHours.toStringAsFixed(1)} jam',
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Rekomendasi AI',
                            value: _recommendation,
                          ),
                        ] else ...[
                          Text(
                            widget.draft.serviceOption == null
                                ? 'Estimasi waktu tersedia setelah pemeriksaan bengkel.'
                                : 'Estimasi waktu dan harga final ${widget.draft.serviceOption} dikonfirmasi setelah pemeriksaan kendaraan.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
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
                      color: AppColors.cardBg,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Divider(height: 20),
                        _DetailRow(
                            label: 'Layanan',
                            value: widget.draft.serviceName ?? '-'),
                        if (widget.draft.serviceOption != null) ...[
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Opsi',
                            value: widget.draft.serviceOption!,
                          ),
                        ],
                        const SizedBox(height: 10),
                        _DetailRow(
                          label: 'Kendaraan',
                          value: vehicle == null
                              ? 'Pilih kendaraan terlebih dahulu'
                              : '${vehicle.brand} ${vehicle.model} (${vehicle.year})',
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          label: 'Nomor Polisi',
                          value: vehicle?.platNumber ?? '-',
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          label: 'Jarak Tempuh',
                          value:
                              vehicle == null ? '-' : '${vehicle.kilometer} KM',
                        ),
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
                      color: AppColors.cardBg,
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
                            color: AppColors.textPrimary,
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
                            fillColor: AppColors.softBg,
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
                  onPressed: _isLoading ||
                          !widget.draft.isComplete ||
                          widget.draft.vehicle == null
                      ? null
                      : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B45),
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
            color: AppColors.textMuted,
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
              color:
                  isHighlight ? const Color(0xFFFF3B45) : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
