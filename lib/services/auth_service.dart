import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_service.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;

  /// Sign In with Email & Password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();

    final credential = await _auth.signInWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    if (credential.user != null) {
      await UserProfileService.ensure(credential.user!);
    }

    return credential;
  }

  /// Sign Up with Email & Password
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name.trim());
    await UserProfileService.ensure(credential.user!, name: name.trim());

    return credential;
  }

  /// Sign In with Google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      await UserProfileService.ensure(userCredential.user!);
    }

    return userCredential;
  }

  /// Reset Password
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Update Complete Profile
  Future<void> updateProfile({required String phone, required String address}) async {
    final uid = currentUid;
    if (uid != null) {
      await UserProfileService.ensure(_auth.currentUser!);
      await _db.collection('users').doc(uid).update({
        'phone': phone.trim(),
        'address': address.trim(),
        'profileCompleted': true,
      });
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
