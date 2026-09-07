import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/context_ext.dart';

enum ShopTab { brands, nearby, marketplace }

const Map<ShopTab, String> kShopTabLabels = {
  ShopTab.brands: 'Top Brands',
  ShopTab.nearby: 'Nearby Stores',
  ShopTab.marketplace: '1Fi Marketplace',
};

class ShopTabs extends StatelessWidget {
  final ShopTab active;
  final ValueChanged<ShopTab> onChanged;

  const ShopTabs({super.key, required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.track,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: ShopTab.values.map((tab) {
          final isActive = tab == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isActive ? c.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        kShopTabLabels[tab]!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isActive ? c.accent500 : c.text2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 20,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: isActive ? c.accent500 : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
