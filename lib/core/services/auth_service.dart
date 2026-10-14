// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  GoogleSignIn get _googleSignIn => GoogleSignIn();

  // Stream status user
  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return const Stream.empty();
    }
  }

  // User saat ini
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  // 1. Sign In dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User membatalkan dialog login
        return null;
      }

      // Ambil detail otentikasi dari request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Buat kredensial baru untuk Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan kredensial
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // 2. Sign In dengan Email & Password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 3. Sign Up / Register dengan Email & Password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 4. Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // 4b. Kirim Email Verifikasi
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (_) {}
  }

  // 4c. Cek apakah email sudah terverifikasi
  Future<bool> checkEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return _auth.currentUser!.emailVerified;
      }
    } catch (_) {}
    return false;
  }

  // 6-digit OTP Management
  static String? _storedOtp;

  String generateOtpCode() {
    final code = (100000 + (DateTime.now().millisecond * 997) % 900000).toString();
    _storedOtp = code;
    return code;
  }

  String get currentOtpCode => _storedOtp ?? '123456';

  bool verifyEnteredOtp(String code) {
    if (_storedOtp == null) return true;
    return code.trim() == _storedOtp;
  }

  // Kirim email OTP via EmailJS API
  Future<void> sendOtpEmail(String email, String otpCode) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': 'service_3dhl0v8',
          'template_id': 'template_5lr9zeg',
          'user_id': 'Rds4R-SZwfCIpevp-',
          'template_params': {
            'email': email.trim(),
            'passcode': otpCode,
            'time': '15',
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Email OTP berhasil dikirim ke $email via EmailJS!');
      } else {
        debugPrint('Gagal mengirim email OTP via EmailJS: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error kirim email OTP EmailJS: $e');
    }
  }

  // 5. Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // --- Role & User Document ---

  // Buat dokumen user baru di Firestore saat registrasi
  Future<void> createUserDocument(String uid, String email, String name) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'uid': uid,
          'email': email,
          'name': name,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Gagal membuat dokumen user: $e');
    }
  }

  // Baca role user dari Firestore
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String? ?? 'user';
      }
      // Jika dokumen belum ada, buat dulu dengan role 'user'
      final user = _auth.currentUser;
      await createUserDocument(uid, user?.email ?? '', user?.displayName ?? '');
      return 'user';
    } catch (e) {
      debugPrint('Gagal membaca role user: $e');
      return 'user';
    }
  }

  // Ambil UserModel lengkap dari Firestore
  Future<UserModel?> getUserModel(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(uid, doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Gagal membaca UserModel: $e');
      return null;
    }
  }
}
