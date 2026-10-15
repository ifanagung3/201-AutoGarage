import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingWaktuScreen extends StatefulWidget {
  const BookingWaktuScreen({super.key});

  @override
  State<BookingWaktuScreen> createState() => _BookingWaktuScreenState();
}

class _BookingWaktuScreenState extends State<BookingWaktuScreen> {
  String? selectedTime;

  final List<String> timeSlots = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pilih Waktu',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
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
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3B82F6)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
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
                  onPressed: selectedTime == null
                      ? null
                      : () => context.go('/booking/konfirmasi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Lanjut',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
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
}
