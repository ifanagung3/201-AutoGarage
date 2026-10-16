import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/service_estimation_model.dart';
import '../../services/random_forest_service.dart';

class EstimasiBiayaScreen extends StatefulWidget {
  const EstimasiBiayaScreen({super.key});

  @override
  State<EstimasiBiayaScreen> createState() => _EstimasiBiayaScreenState();
}

class _EstimasiBiayaScreenState extends State<EstimasiBiayaScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String _selectedCategory = 'Servis Rutin';
  String _selectedVehicleType = 'MPV';
  int _selectedYear = 2020;
  int _kilometer = 35000;

  bool _replaceEngineOil = true;
  bool _replaceFilter = false;
  bool _replaceBrakePad = false;
  bool _replaceSparkPlugs = false;

  ServiceEstimationResult? _result;

  final List<String> _categories = [
    'Servis Rutin',
    'Tune Up',
    'AC Service',
    'Ganti Ban',
    'Kaki-kaki',
    'Overhaul Mesin',
  ];

  final List<String> _vehicleTypes = [
    'MPV',
    'SUV',
    'Sedan',
    'Hatchback',
    'City Car',
  ];

  @override
  void initState() {
    super.initState();
    _calculateEstimation();
  }

  void _calculateEstimation() {
    final input = ServiceEstimationInput(
      category: _selectedCategory,
      vehicleType: _selectedVehicleType,
      year: _selectedYear,
      kilometer: _kilometer,
      replaceEngineOil: _replaceEngineOil,
      replaceFilter: _replaceFilter,
      replaceBrakePad: _replaceBrakePad,
      replaceSparkPlugs: _replaceSparkPlugs,
    );

    setState(() {
      _result = RandomForestService.instance.predictCost(input);
    });
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = RandomForestService.instance.getModelMetrics();

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
            'Kalkulator Estimasi Biaya (Random Forest)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBack,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B8DEF), Color(0xFF3872E0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prediksi Biaya Berbasis Machine Learning',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Algoritma Random Forest Regression (Akurasi R² ${metrics['rSquared']})',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Form Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Kendaraan & Layanan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    Text(
                      'Jenis Layanan',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.poppins(fontSize: 14))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _selectedCategory = val;
                          _calculateEstimation();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Vehicle Type & Year Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tipe Bodi', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _selectedVehicleType,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                items: _vehicleTypes
                                    .map((v) => DropdownMenuItem(value: v, child: Text(v, style: GoogleFonts.poppins(fontSize: 14))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _selectedVehicleType = val;
                                    _calculateEstimation();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tahun Pembuatan', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<int>(
                                value: _selectedYear,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                                items: List.generate(20, (index) => 2026 - index)
                                    .map((y) => DropdownMenuItem(value: y, child: Text(y.toString(), style: GoogleFonts.poppins(fontSize: 14))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _selectedYear = val;
                                    _calculateEstimation();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Kilometer Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Jarak Tempuh (Kilometer)', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                        Text('${_kilometer.toString()} KM', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF5B8DEF))),
                      ],
                    ),
                    Slider(
                      value: _kilometer.toDouble(),
                      min: 5000,
                      max: 200000,
                      divisions: 39,
                      activeColor: const Color(0xFF5B8DEF),
                      onChanged: (val) {
                        _kilometer = val.round();
                        _calculateEstimation();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Spareparts Options
                    Text('Pilihan Komponen / Replacement', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Oli Mesin Synth (4 Liter)', style: GoogleFonts.poppins(fontSize: 13)),
                      value: _replaceEngineOil,
                      activeColor: const Color(0xFF5B8DEF),
                      onChanged: (val) {
                        _replaceEngineOil = val ?? false;
                        _calculateEstimation();
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Filter Oli & Filter Udara', style: GoogleFonts.poppins(fontSize: 13)),
                      value: _replaceFilter,
                      activeColor: const Color(0xFF5B8DEF),
                      onChanged: (val) {
                        _replaceFilter = val ?? false;
                        _calculateEstimation();
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Kampas Rem (Brake Pad Set)', style: GoogleFonts.poppins(fontSize: 13)),
                      value: _replaceBrakePad,
                      activeColor: const Color(0xFF5B8DEF),
                      onChanged: (val) {
                        _replaceBrakePad = val ?? false;
                        _calculateEstimation();
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text('Busi Iridium Set', style: GoogleFonts.poppins(fontSize: 13)),
                      value: _replaceSparkPlugs,
                      activeColor: const Color(0xFF5B8DEF),
                      onChanged: (val) {
                        _replaceSparkPlugs = val ?? false;
                        _calculateEstimation();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Results Section
              if (_result != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF5B8DEF).withOpacity(0.3), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Hasil Prediksi Estimasi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Akurasi 94%',
                              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Estimated Price Display
                      Center(
                        child: Column(
                          children: [
                            Text('Estimasi Biaya Total', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                            const SizedBox(height: 4),
                            Text(
                              _currencyFormat.format(_result!.estimatedCost),
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF5B8DEF),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rentang Estimasi: ${_currencyFormat.format(_result!.minCost)} - ${_currencyFormat.format(_result!.maxCost)}',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Cost Breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _CostDetailTile(
                            title: 'Biaya Jasa',
                            value: _currencyFormat.format(_result!.laborCost),
                            icon: Icons.engineering,
                          ),
                          _CostDetailTile(
                            title: 'Sparepart',
                            value: _currencyFormat.format(_result!.sparepartCost),
                            icon: Icons.extension,
                          ),
                          _CostDetailTile(
                            title: 'Durasi',
                            value: '${_result!.estimatedDurationMinutes} Mnt',
                            icon: Icons.timer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Model Evaluation Metrics Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MetricItem(label: 'MAPE Error', value: '${metrics['mape']}%'),
                            _MetricItem(label: 'R-Squared', value: '${metrics['rSquared']}'),
                            _MetricItem(label: 'RMSE', value: 'Rp 18.5k'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Booking Action Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/booking/layanan');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B8DEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjut Booking Servis Ini',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CostDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _CostDetailTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5B8DEF), size: 22),
        const SizedBox(height: 4),
        Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF5B8DEF))),
      ],
    );
  }
}
