import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product.dart';
import '../theme/context_ext.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'section_label.dart';

/// A rounded-rectangle "bubble" chip for a text variant option
/// (Storage / Size), showing the option label and its absolute price.
class ChipBubble extends StatelessWidget {
  final String label;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  const ChipBubble({
    super.key,
    required this.label,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minWidth: 78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? c.accent50 : c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? c.accent500 : c.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: selected ? c.accent600 : c.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rupees(price),
              style: TextStyle(fontSize: 11, color: c.text2),
            ),
          ],
        ),
      ),
    );
  }
}

/// A rounded-rectangle chip holding a small color swatch and the option's
/// name side by side. Selection highlights the whole chip (tint + border),
/// matching [ChipBubble] rather than ringing the swatch on its own.
class ColorBubble extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const ColorBubble({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? c.accent50 : c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? c.accent500 : c.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? c.accent600 : c.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A collapsible "SELECT YOUR {axis}" section: header with a chevron that
/// flips, and either the chip bubbles or color bubbles beneath it.
class VariantSection extends StatelessWidget {
  final ProductVariant variant;
  final Product product;
  final bool collapsed;
  final VoidCallback onToggle;
  final String Function(Product, String) selectedValue;
  final void Function(Product, String, String) onSelect;
  final int Function(Product, String, VariantOption) priceForOption;

  const VariantSection({
    super.key,
    required this.variant,
    required this.product,
    required this.collapsed,
    required this.onToggle,
    required this.selectedValue,
    required this.onSelect,
    required this.priceForOption,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sel = selectedValue(product, variant.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionLabel('Select your ${variant.type}'),
                AnimatedRotation(
                  turns: collapsed ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 18, color: c.text2),
                ),
              ],
            ),
          ),
        ),
        if (!collapsed) ...[
          const SizedBox(height: 10),
          if (variant.isColor)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: variant.options.map((o) {
                return ColorBubble(
                  label: o.label,
                  color: hexToColor(o.hex!),
                  selected: sel == o.label,
                  onTap: () => onSelect(product, variant.type, o.label),
                );
              }).toList(),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: variant.options.map((o) {
                return ChipBubble(
                  label: o.label,
                  price: priceForOption(product, variant.type, o),
                  selected: sel == o.label,
                  onTap: () => onSelect(product, variant.type, o.label),
                );
              }).toList(),
            ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
