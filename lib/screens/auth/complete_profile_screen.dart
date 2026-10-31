import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/user_profile_service.dart';
import 'auth_visuals.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Future<void> _completeProfile() async {
    if (_phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserProfileService.ensure(user);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'profileCompleted': true,
        });
        if (mounted) context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
        backgroundColor: Color(0xFF0B0E13),
        appBar: AppBar(
          backgroundColor: Color(0xFF0B0E13),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: authInk),
            onPressed: _handleBack,
          ),
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 29),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Your Profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: authInk,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lengkapi profil Anda untuk melanjutkan',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: authMuted),
                    ),
                    const SizedBox(height: 36),

                    // Phone Number Input
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: !_isLoading,
                      style: GoogleFonts.poppins(fontSize: 14, color: authInk),
                      decoration: InputDecoration(
                        hintText: 'Nomor Telepon',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFADB0BF)),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F6),
                        prefixIcon: const Icon(Icons.phone_outlined,
                            size: 23, color: Color(0xFFC5C7D2)),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide:
                              const BorderSide(color: Color(0xFF6678CB)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address Input
                    TextField(
                      controller: _addressController,
                      maxLines: 3,
                      enabled: !_isLoading,
                      style: GoogleFonts.poppins(fontSize: 14, color: authInk),
                      decoration: InputDecoration(
                        hintText: 'Alamat Lengkap',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFADB0BF)),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F6),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Icon(Icons.location_on_outlined,
                              size: 23, color: Color(0xFFC5C7D2)),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide:
                              const BorderSide(color: Color(0xFF6678CB)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Complete Button
                    GradientAction(
                      onPressed: _isLoading ? null : _completeProfile,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Complete Profile',
                              style: GoogleFonts.poppins(fontSize: 16)),
                    ),
                    const SizedBox(height: 16),

                    // Skip Button
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(
                          'Lewati',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: authMuted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
