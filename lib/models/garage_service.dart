import 'package:flutter/material.dart';

class GarageService {
  const GarageService({
    required this.name,
    required this.description,
    required this.priceLabel,
    required this.basePrice,
    required this.group,
    required this.icon,
    this.priceNote,
    this.estimationCategory,
    this.options = const [],
  });

  final String name;
  final String description;
  final String priceLabel;
  final int basePrice;
  final String group;
  final IconData icon;
  final String? priceNote;
  final String? estimationCategory;
  final List<String> options;
}

class GarageServiceCatalog {
  static const services = <GarageService>[
    GarageService(
      name: 'Servis Berkala',
      description:
          'Tune-up, pembersihan throttle body, pemeriksaan 40 titik dan sistem rem.',
      priceLabel: 'Rp 350.000',
      basePrice: 350000,
      group: 'Servis Rutin',
      icon: Icons.build_circle_outlined,
      estimationCategory: 'Servis Rutin',
    ),
    GarageService(
      name: 'Ganti Oli Mesin & Transmisi',
      description:
          'Pilihan oli sesuai spesifikasi kendaraan dan penggantian filter oli.',
      priceLabel: 'Rp 150.000 (jasa)',
      basePrice: 150000,
      group: 'Servis Rutin',
      icon: Icons.oil_barrel_outlined,
      priceNote: 'Harga jasa; oli dan filter mengikuti pilihan kendaraan.',
      estimationCategory: 'Servis Rutin',
    ),
    GarageService(
      name: 'Overhaul Mesin (Turun Mesin)',
      description:
          'Pemeriksaan ruang bakar, skir klep, packing, piston dan komponen mesin.',
      priceLabel: 'Rp 2.500.000',
      basePrice: 2500000,
      group: 'Servis Rutin',
      icon: Icons.settings_outlined,
      priceNote:
          'Harga awal; kebutuhan suku cadang ditentukan setelah pemeriksaan.',
      estimationCategory: 'Overhaul Mesin',
    ),
    GarageService(
      name: 'Perawatan Sistem Rem & Understeel',
      description: 'Pemeriksaan rem, kampas, bushing arm dan shock absorber.',
      priceLabel: 'Rp 200.000',
      basePrice: 200000,
      group: 'Servis Rutin',
      icon: Icons.car_repair_outlined,
      priceNote: 'Harga awal; suku cadang dapat dikenakan biaya terpisah.',
      estimationCategory: 'Kaki-kaki',
    ),
    GarageService(
      name: 'AC Service',
      description: 'Pembersihan dan pengisian freon AC.',
      priceLabel: 'Rp 200.000',
      basePrice: 200000,
      group: 'Servis Rutin',
      icon: Icons.ac_unit_outlined,
      estimationCategory: 'AC Service',
    ),
    GarageService(
      name: 'Tune Up',
      description: 'Pembersihan mesin dan penyetelan performa.',
      priceLabel: 'Rp 300.000',
      basePrice: 300000,
      group: 'Servis Rutin',
      icon: Icons.tune_outlined,
      estimationCategory: 'Tune Up',
    ),
    GarageService(
      name: 'Ganti Ban',
      description: 'Penggantian dan balancing ban mobil.',
      priceLabel: 'Rp 400.000',
      basePrice: 400000,
      group: 'Servis Rutin',
      icon: Icons.tire_repair_outlined,
      estimationCategory: 'Ganti Ban',
    ),
    GarageService(
      name: 'Tuning ECU & Remap Stage 1 / 2',
      description: 'Optimasi kurva torsi dan tenaga; dyno baseline termasuk.',
      priceLabel: 'Rp 800.000–2.500.000',
      basePrice: 800000,
      group: 'Performa & Diesel',
      icon: Icons.memory_outlined,
      priceNote: 'Harga akhir mengikuti kendaraan dan pilihan stage.',
      options: ['Stage 1', 'Stage 2'],
    ),
    GarageService(
      name: 'Purging Diesel & Kalibrasi Injektor',
      description: 'Pembersihan deposit solar common rail tanpa bongkar mesin.',
      priceLabel: 'Rp 450.000',
      basePrice: 450000,
      group: 'Performa & Diesel',
      icon: Icons.science_outlined,
    ),
    GarageService(
      name: 'Pemasangan Downpipe Stainless 304',
      description:
          'Pilihan PnP untuk Innova, Fortuner dan Pajero; konfirmasi kecocokan kendaraan.',
      priceLabel: 'Rp 1.450.000',
      basePrice: 1450000,
      group: 'Performa & Diesel',
      icon: Icons.air_outlined,
    ),
  ];

  static GarageService? findByName(String? name) {
    for (final service in services) {
      if (service.name == name) return service;
    }
    return null;
  }
}
