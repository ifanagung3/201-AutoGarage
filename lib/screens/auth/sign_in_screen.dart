import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_visuals.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _signInWithEmail() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      String msg = 'Login gagal: ${e.message}';
      if (e.code == 'user-not-found') msg = 'Akun belum terdaftar';
      if (e.code == 'wrong-password') msg = 'Password salah';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
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

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3F8FB),
              Colors.white,
              Color(0xFFF7F6FB),
              Colors.white
            ],
            stops: [0, 0.35, 0.65, 1],
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(29, 40, 29, 32),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                          child: SizedBox(
                        width: 198,
                        child: ReferenceArtwork(logo: true),
                      )),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat Datang Kembali',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: authInk,
                          letterSpacing: -0.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk ke akun Anda menggunakan\nemail atau akun sosial anda',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 14, height: 1.6, color: authMuted),
                      ),
                      const SizedBox(height: 34),
                      _input(password: false),
                      const SizedBox(height: 22),
                      _input(password: true),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go('/forgot-password'),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text('Forgot Password?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF6475D5),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GradientAction(
                        onPressed: _isLoading ? null : _signInWithEmail,
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text('Sign In',
                                style: GoogleFonts.poppins(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('First time here?',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: authInk)),
                            TextButton(
                              onPressed: () => context.go('/sign-up'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(left: 4),
                                minimumSize: const Size(0, 48),
                              ),
                              child: Text('Sign up',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF6475D5),
                                  )),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        const Expanded(
                            child: Divider(color: Color(0xFFE8E8EB))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Or sign in with',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: authInk)),
                        ),
                        const Expanded(
                            child: Divider(color: Color(0xFFE8E8EB))),
                      ]),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(
                            child: _social(
                          label: 'Google',
                          icon: const CustomPaint(
                              size: Size(20, 20),
                              painter: _GoogleMarkPainter()),
                          onPressed: _isLoading ? null : _signInWithGoogle,
                        )),
                        const SizedBox(width: 20),
                        Expanded(
                            child: _social(
                          label: 'Facebook',
                          icon: const Icon(Icons.facebook,
                              color: Color(0xFF1877F2), size: 25),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Login Facebook belum dikonfigurasi. Gunakan email atau Google.')),
                                  );
                                },
                        )),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({required bool password}) => TextField(
        controller: password ? _passwordController : _emailController,
        obscureText: password && _obscurePassword,
        enabled: !_isLoading,
        autocorrect: false,
        enableSuggestions: !password,
        keyboardType: password
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        textInputAction: password ? TextInputAction.done : TextInputAction.next,
        autofillHints: password
            ? const [AutofillHints.password]
            : const [AutofillHints.email],
        onSubmitted: password
            ? (_) {
                if (!_isLoading) _signInWithEmail();
              }
            : null,
        style: GoogleFonts.poppins(fontSize: 14, color: authInk),
        decoration: InputDecoration(
          hintText: password ? 'Password' : 'Email',
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFADB0BF)),
          filled: true,
          fillColor: const Color(0xFFF0F0F6),
          prefixIcon: Icon(
              password
                  ? Icons.lock_outline_rounded
                  : Icons.mail_outline_rounded,
              size: 23,
              color: const Color(0xFFC5C7D2)),
          prefixIconConstraints: const BoxConstraints(minWidth: 54),
          suffixIcon: password
              ? IconButton(
                  tooltip: _obscurePassword
                      ? 'Tampilkan password'
                      : 'Sembunyikan password',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFFC5C7D2),
                      size: 23),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: Color(0xFF6678CB))),
        ),
      );

  Widget _social(
      {required String label,
      required Widget icon,
      required VoidCallback? onPressed}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF7F8FA),
          foregroundColor: authInk,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          side: const BorderSide(color: Color(0xFFEEEEF1)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          icon,
          const SizedBox(width: 6),
          Flexible(
              child: Text(label, style: GoogleFonts.poppins(fontSize: 16))),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

/// Local vector icon: avoids passing an SVG to Flutter's raster decoder.
class _GoogleMarkPainter extends CustomPainter {
  const _GoogleMarkPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    const bounds = Rect.fromLTWH(3, 3, 18, 18);
    const pi = 3.141592653589793;
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(bounds, 0, pi / 3, false, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(bounds, pi / 3, pi / 2, false, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(bounds, 5 * pi / 6, pi / 3, false, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(bounds, 7 * pi / 6, 7 * pi / 12, false, paint);
    paint.color = const Color(0xFF4285F4);
    canvas.drawLine(const Offset(12, 12), const Offset(21, 12), paint);
    canvas.drawLine(const Offset(21, 12), const Offset(21, 15), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
