import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/context_ext.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: c.border)),
          child: Icon(icon, size: 16, color: c.text),
        ),
      ),
    );
  }
}

/// The sticky bottom bar showing a price/label pair and a primary CTA,
/// used by both the product page and the Pay using 1Fi screen.
class CtaBar extends StatelessWidget {
  final String label;
  final String amountText;
  final String buttonText;
  final VoidCallback onPressed;

  const CtaBar({
    super.key,
    required this.label,
    required this.amountText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 11, color: c.text2)),
                  Text(
                    amountText,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: c.text),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.accent500,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
