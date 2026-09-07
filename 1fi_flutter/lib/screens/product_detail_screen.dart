import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/context_ext.dart';
import '../theme/tokens.dart';
import '../util/format.dart';
import '../widgets/common_buttons.dart';
import '../widgets/variant_selectors.dart';
import 'pay_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Map<String, bool> _collapsed = {};

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final p = widget.product;
    final price = app.currentPrice(p);
    final pct = p.discountPct;
    final emiTenures = kTenures.where((t) => t <= p.maxTenure).toList();

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p.name,
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            hexToColor(p.grad[0]),
                            hexToColor(p.grad[1]),
                          ],
                        ),
                      ),
                      child: Icon(iconForProduct(p.icon),
                          size: 76, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: c.text3,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: c.text,
                            ),
                          ),
                        ),
                        CircleIconButton(
                          icon: Icons.share_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 15, color: c.gold),
                        const SizedBox(width: 4),
                        Text(
                          '${p.rating}',
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: c.text),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${p.reviews} reviews)',
                          style: TextStyle(fontSize: 12.5, color: c.text2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          rupees(price),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: c.text,
                          ),
                        ),
                        if (pct > 0) ...[
                          const SizedBox(width: 10),
                          Text(
                            rupees(p.mrp),
                            style: TextStyle(
                              fontSize: 14,
                              color: c.text3,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$pct% off',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: c.gold),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...p.variants.map((v) {
                      final key = '${p.id}|${v.type}';
                      return VariantSection(
                        variant: v,
                        product: p,
                        collapsed: _collapsed[key] ?? false,
                        onToggle: () => setState(
                            () => _collapsed[key] = !(_collapsed[key] ?? false)),
                        selectedValue: (product, type) =>
                            app.selectedVariant(product, type),
                        onSelect: (product, type, value) =>
                            context.read<AppState>().selectVariant(
                                product, type, value),
                        priceForOption: (product, type, o) =>
                            app.priceForOption(product, type, o),
                      );
                    }),
                    const SizedBox(height: 12),
                    Text(
                      'Highlights',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: c.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...p.highlights.map((h) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.eco_outlined,
                                  size: 15, color: c.accent500),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  h,
                                  style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: c.text2),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    Text(
                      'EMI PLANS AVAILABLE',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: c.text2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 62,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: emiTenures.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final t = emiTenures[i];
                          final monthly = price / t;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: c.surfaceTint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$t mo',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: c.text),
                                ),
                                Text(
                                  '${rupees(monthly)}/mo',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: c.accent600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pick a plan on the next screen',
                      style: TextStyle(fontSize: 11.5, color: c.text3),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: c.surfaceTint,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 16, color: c.accent500),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Buy now, pay later with EMI — backed by your mutual fund investments on 1Fi.',
                              style: TextStyle(
                                  fontSize: 12, height: 1.55, color: c.text2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CtaBar(
              label: 'Price',
              amountText: rupees(price),
              buttonText: 'Pay using 1Fi',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PayScreen(product: p)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
