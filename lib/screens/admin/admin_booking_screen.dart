import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabs.dispose();
    super.dispose();
  }

  // Admin manual booking — collects customer name/phone directly since
  // the booking is created under the admin account (no customer UID available).
  void _showManualBookingDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final vehicleController = TextEditingController(text: 'Toyota Avanza');
    final platController = TextEditingController(text: 'B 1234 AG');
    final serviceController = TextEditingController(text: 'Servis Berkala');
    final costController = TextEditingController(text: '350000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(
          'Tambah Booking Manual',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              TextField(
                controller: phoneController,
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor HP Pelanggan',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              TextField(
                controller: vehicleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Kendaraan',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              TextField(
                controller: platController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Nomor Plat',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              TextField(
                controller: serviceController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Jenis Layanan',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
              TextField(
                controller: costController,
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimasi Biaya (Rp)',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  vehicleController.text.isNotEmpty) {
                try {
                  // createBooking uses the currently signed-in user (admin) as
                  // userId. The customer name/phone override is written directly
                  // to the document via updateBookingDetails after creation so
                  // the admin-entered values are stored correctly.
                  final bookingId =
                      await BookingService.instance.createBooking(
                    vehicleName: vehicleController.text.trim(),
                    vehiclePlat: platController.text.trim(),
                    vehicleYear: 2020,
                    vehicleKm: 35000,
                    serviceName: serviceController.text.trim(),
                    bookingDate: DateTime.now(),
                    bookingTime: '09:00 WIB',
                    estimatedCost:
                        double.tryParse(costController.text.trim()) ??
                            350000,
                    notes: 'Booking manual oleh Admin',
                  );

                  // Patch customer name and phone with admin-provided values.
                  if (nameController.text.trim().isNotEmpty ||
                      phoneController.text.trim().isNotEmpty) {
                    await BookingService.instance.patchManualBookingContact(
                      bookingId: bookingId,
                      userName: nameController.text.trim(),
                      userPhone: phoneController.text.trim(),
                    );
                  }

                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (error) {
                  debugPrint('Failed to create manual booking: $error');
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('Gagal membuat booking: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B45),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(title,
            style: GoogleFonts.poppins(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(message,
            style: GoogleFonts.poppins(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B45)),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        title: Text('Kelola Booking',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: const Color(0xFFFF3B45),
          labelColor: const Color(0xFFFF3B45),
          unselectedLabelColor: AppColors.textMuted,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Menunggu'),
            Tab(text: 'Proses'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari nama, plat nomor, atau layanan...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<BookingModel>>(
              stream: BookingService.instance.streamAllBookings(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Gagal memuat booking: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                              color: AppColors.textPrimary)),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFFF3B45)));
                }

                final allBookings = snapshot.data!;
                final filtered = allBookings.where((b) {
                  final q = _searchQuery.toLowerCase();
                  return b.userName.toLowerCase().contains(q) ||
                      b.vehiclePlat.toLowerCase().contains(q) ||
                      b.serviceName.toLowerCase().contains(q) ||
                      (b.serviceOption?.toLowerCase().contains(q) ?? false) ||
                      b.id.toLowerCase().contains(q);
                }).toList();

                return TabBarView(
                  controller: _tabs,
                  children: [
                    _BookingList(
                        bookings: filtered,
                        confirmAction: _confirmAction),
                    _BookingList(
                        bookings: filtered
                            .where((b) => b.status == 'Menunggu')
                            .toList(),
                        confirmAction: _confirmAction),
                    _BookingList(
                        bookings: filtered
                            .where((b) =>
                                b.status == 'Proses Pengecekan' ||
                                b.status == 'Sedang Dikerjakan' ||
                                b.status == 'Quality Check')
                            .toList(),
                        confirmAction: _confirmAction),
                    _BookingList(
                        bookings: filtered
                            .where((b) =>
                                b.status == 'Selesai' ||
                                b.status == 'Dibatalkan')
                            .toList(),
                        confirmAction: _confirmAction),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualBookingDialog(context),
        backgroundColor: const Color(0xFFFF3B45),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Booking',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final Function(BuildContext,
      {required String title,
      required String message,
      required VoidCallback onConfirm}) confirmAction;

  const _BookingList({required this.bookings, required this.confirmAction});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('Tidak ada data booking',
            style: GoogleFonts.poppins(color: AppColors.textMuted)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF3B45),
                          fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (booking.status == 'Selesai'
                              ? const Color(0xFF10B981)
                              : booking.status == 'Dibatalkan'
                                  ? Colors.red
                                  : const Color(0xFFFF3B45))
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(booking.status,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: booking.status == 'Selesai'
                                ? const Color(0xFF10B981)
                                : booking.status == 'Dibatalkan'
                                    ? Colors.redAccent
                                    : const Color(0xFFFF3B45))),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  'Pelanggan: ${booking.userName} (${booking.userPhone})',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textPrimary)),
              Text(
                  'Kendaraan: ${booking.vehicleName} [${booking.vehiclePlat}]',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textPrimary)),
              Text('Layanan: ${booking.serviceName}',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
              if (booking.serviceOption != null)
                Text('Opsi: ${booking.serviceOption}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (booking.status == 'Menunggu') ...[
                    ElevatedButton(
                      onPressed: () => confirmAction(
                        context,
                        title: 'Terima Booking?',
                        message:
                            'Booking ${booking.id} akan diproses ke tahap Pengecekan.',
                        onConfirm: () =>
                            BookingService.instance.updateBookingStatus(
                                booking.id, 'Proses Pengecekan', 2),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981)),
                      child: const Text('Terima'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => confirmAction(
                        context,
                        title: 'Tolak Booking?',
                        message:
                            'Booking ${booking.id} akan dibatalkan.',
                        // FIX: step must be 0 for Dibatalkan (Firestore rules enforce this)
                        onConfirm: () =>
                            BookingService.instance.updateBookingStatus(
                                booking.id, 'Dibatalkan', 0),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Text('Tolak'),
                    ),
                  ],
                  const Spacer(),
                  if (booking.status != 'Selesai' &&
                      booking.status != 'Dibatalkan')
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      tooltip: 'Batalkan Booking',
                      onPressed: () => confirmAction(
                        context,
                        title: 'Batalkan Booking?',
                        message:
                            'Apakah Anda yakin ingin membatalkan ${booking.id}?',
                        onConfirm: () =>
                            BookingService.instance.cancelBooking(booking.id),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
