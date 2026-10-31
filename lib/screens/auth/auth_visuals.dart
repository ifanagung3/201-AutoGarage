import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

const authInk = AppColors.authInk;
const authMuted = AppColors.authMuted;
const authInputBg = Color(0xFF171C24);
const authOutline = Color(0xFF2A313C);
const authGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFF3B45), Color(0xFFB91C2C)],
);

/// Displays only the artwork from the supplied design at its original ratio.
/// Text, controls and system bars are rendered separately as real widgets.
class ReferenceArtwork extends StatelessWidget {
  const ReferenceArtwork({super.key, required this.logo});
  final bool logo;

  @override
  Widget build(BuildContext context) {
    if (logo) {
      return Image.asset(
        'assets/images/201_auto_garage_brand.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        excludeFromSemantics: true,
      );
    }

    const rect = Rect.fromLTWH(0, 400, 430, 494);
    return AspectRatio(
      aspectRatio: rect.width / rect.height,
      child: LayoutBuilder(builder: (context, constraints) {
        final scale = constraints.maxWidth / rect.width;
        return ClipRect(
          child: Stack(children: [
            Positioned(
              left: -rect.left * scale,
              top: -rect.top * scale,
              width: 430 * scale,
              height: 932 * scale,
              child: Image.asset(
                'assets/images/onboarding_reference.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                excludeFromSemantics: true,
              ),
            ),
          ]),
        );
      }),
    );
  }
}

class GradientAction extends StatelessWidget {
  const GradientAction(
      {super.key, required this.child, required this.onPressed});
  final Widget child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: authGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w400),
            minimumSize: const Size(0, 50),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: child,
        ),
      );
}
