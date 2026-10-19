import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingWaktuScreen extends StatefulWidget {
  final String serviceName;
  final String bookingDate;

  const BookingWaktuScreen({
    super.key,
    required this.serviceName,
    required this.bookingDate,
  });

  @override
  State<BookingWaktuScreen> createState() => _BookingWaktuScreenState();
}

class _BookingWaktuScreenState extends State<BookingWaktuScreen> {
  String? selectedTime = '09:00 WIB';
  final List<String> timeSlots = ['08:00 WIB', '09:00 WIB', '10:00 WIB', '11:00 WIB', '13:00 WIB', '14:00 WIB', '15:00 WIB', '16:00 WIB'];

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/booking/tanggal?service=${Uri.encodeComponent(widget.serviceName)}');
    }
  }

  void _proceedToConfirmation() {
    if (selectedTime == null) return;
    context.go('/booking/konfirmasi?service=${Uri.encodeComponent(widget.serviceName)}&date=${Uri.encodeComponent(widget.bookingDate)}&time=${Uri.encodeComponent(selectedTime!)}');
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
          title: Text('Pilih Jam (${widget.serviceName})'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final time = timeSlots[index];
                  final isSelected = selectedTime == time;
                  return InkWell(
                    onTap: () => setState(() => selectedTime = time),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                        border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedTime == null ? null : _proceedToConfirmation,
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
