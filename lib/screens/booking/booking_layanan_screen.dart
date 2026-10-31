import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../models/booking_draft.dart';
import '../../models/garage_service.dart';
import '../../models/vehicle_model.dart';
import '../../services/vehicle_service.dart';

class BookingLayananScreen extends StatefulWidget {
  const BookingLayananScreen({super.key, this.initialDraft});

  final BookingDraft? initialDraft;

  @override
  State<BookingLayananScreen> createState() => _BookingLayananScreenState();
}

class _BookingLayananScreenState extends State<BookingLayananScreen> {
  String? _selectedVehicleId;

  @override
  void initState() {
    super.initState();
    _selectedVehicleId = widget.initialDraft?.vehicle?.id;
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Future<void> _selectService(
    GarageService service,
    VehicleModel? vehicle,
  ) async {
    if (vehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan dan pilih kendaraan sebelum booking.'),
        ),
      );
      return;
    }

    String? option;
    if (service.options.isNotEmpty) {
      option = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih opsi ${service.name}',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${service.priceLabel}. Harga final dikonfirmasi setelah pemeriksaan kendaraan.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                for (final item in service.options)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFEEEE),
                      child: Icon(
                        Icons.memory_rounded,
                        color: AppColors.accentRed,
                      ),
                    ),
                    title: Text(
                      item,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).pop(item),
                  ),
              ],
            ),
          ),
        ),
      );
      if (option == null) return;
    }

    if (!mounted) return;
    context.push(
      '/booking/tanggal',
      extra: BookingDraft(
        serviceName: service.name,
        serviceOption: option,
        vehicle: vehicle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Servis'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: StreamBuilder<List<VehicleModel>>(
          stream: VehicleService.instance.streamUserVehicles(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Gagal memuat kendaraan: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: AppColors.textPrimary),
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accentRed),
              );
            }

            final vehicles = snapshot.data ?? [];
            VehicleModel? selectedVehicle;
            if (vehicles.isNotEmpty) {
              selectedVehicle = vehicles.cast<VehicleModel?>().firstWhere(
                    (vehicle) => vehicle?.id == _selectedVehicleId,
                    orElse: () => vehicles.first,
                  );
              selectedVehicle ??= vehicles.first;
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                _BookingProgress(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pilih Kendaraan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/akun/kendaraan'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah'),
                    ),
                  ],
                ),
                if (selectedVehicle == null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.outline),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions_car_outlined,
                          color: AppColors.accentRed,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Belum ada kendaraan. Tambahkan kendaraan agar data booking dan estimasi sesuai.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.outline),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<VehicleModel>(
                        value: selectedVehicle,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more_rounded),
                        items: vehicles
                            .map(
                              (vehicle) => DropdownMenuItem(
                                value: vehicle,
                                child: Text(
                                  '${vehicle.fullName} • ${vehicle.platNumber}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (vehicle) => setState(
                          () => _selectedVehicleId = vehicle?.id,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pilih Layanan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Text(
                      'Harga mulai',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final group in GarageServiceCatalog.services
                    .map((service) => service.group)
                    .toSet()) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text(
                      group,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  for (final service in GarageServiceCatalog.services
                      .where((service) => service.group == group))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ServiceCard(
                        service: service,
                        selected:
                            widget.initialDraft?.serviceName == service.name,
                        onTap: () => _selectService(service, selectedVehicle),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookingProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const steps = ['Kendaraan', 'Layanan', 'Jadwal', 'Konfirmasi'];
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i < 2 ? AppColors.accentRed : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: i < 2 ? AppColors.accentRed : AppColors.outline,
                    ),
                  ),
                  child: Text(
                    '${i + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: i < 2 ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  steps[i],
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: i < 2 ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (i < steps.length - 1)
            const Expanded(
              child: Divider(height: 1, color: AppColors.outline),
            ),
        ],
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final GarageService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.accentRed : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  service.icon,
                  color: AppColors.accentRed,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.priceLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentRed,
                      ),
                    ),
                    if (service.priceNote != null)
                      Text(
                        service.priceNote!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
