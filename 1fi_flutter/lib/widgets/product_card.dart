import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product.dart';
import '../theme/context_ext.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final pct = product.discountPct;
    final colorVariant = product.variants
        .where((v) => v.isColor)
        .cast<ProductVariant?>()
        .firstWhere((v) => true, orElse: () => null);

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProductImage(product: product, iconSize: 44),
                    ),
                    if (pct > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: c.goldSoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$pct% OFF',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: c.gold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: c.text3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: c.text,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          rupees(product.price),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: c.text,
                          ),
                        ),
                        if (pct > 0) ...[
                          const SizedBox(width: 6),
                          Text(
                            rupees(product.mrp),
                            style: TextStyle(
                              fontSize: 10,
                              color: c.text3,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: c.accent50,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'EMI from ${rupees(product.price / product.maxTenure)}/mo',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: c.accent600,
                        ),
                      ),
                    ),
                    if (colorVariant != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: colorVariant.options
                            .take(4)
                            .map((o) => Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hexToColor(o.hex!),
                                    border: Border.all(
                                        color:
                                            Colors.black.withValues(alpha: 0.08)),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
