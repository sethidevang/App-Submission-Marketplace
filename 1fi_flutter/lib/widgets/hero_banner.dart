import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/context_ext.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: c.hero,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            bottom: -14,
            child: Icon(Icons.shopping_bag_rounded,
                size: 130, color: Colors.white.withValues(alpha: 0.12)),
          ),
          Positioned(
            right: 30,
            top: 6,
            child: Icon(Icons.auto_awesome_rounded,
                size: 20, color: c.gold.withValues(alpha: 0.9)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.55)),
                ),
                child: const Text(
                  '✦ NO-COST EMIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 230),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      height: 1.16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    children: [
                      const TextSpan(text: 'Shop today,\n'),
                      TextSpan(
                        text: 'Pay later ',
                        style: GoogleFonts.plusJakartaSans(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: 'using\nMutual funds.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: Text(
                  'No credit score required. No interest.\nBacked by your investments.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
