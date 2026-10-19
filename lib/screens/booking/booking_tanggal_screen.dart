import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/booking_draft.dart';

class BookingTanggalScreen extends StatefulWidget {
  const BookingTanggalScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingTanggalScreen> createState() => _BookingTanggalScreenState();
}

class _BookingTanggalScreenState extends State<BookingTanggalScreen> {
  DateTime? selectedDate = DateTime.now().add(const Duration(days: 1));

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/booking/layanan', extra: widget.draft);
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
        appBar: AppBar(
          title: Text('Pilih Tanggal (${widget.draft.serviceName ?? 'Servis'})'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: CalendarDatePicker(
                initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
                onDateChanged: (date) => setState(() => selectedDate = date),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedDate == null
                      ? null
                      : () => context.push(
                            '/booking/waktu',
                            extra: widget.draft.copyWith(
                              bookingDate: selectedDate,
                            ),
                          ),
                  child: const Text('Lanjut'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
