import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/app_state.dart';
import '../theme/context_ext.dart';
import '../util/format.dart';
import '../util/share_product.dart';
import '../widgets/common_buttons.dart';
import '../widgets/confirm_sheet.dart';
import '../widgets/product_image.dart';

class PayScreen extends StatelessWidget {
  final Product product;
  const PayScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final app = context.watch<AppState>();
    final p = product;
    final price = app.currentPrice(p);
    final vSummary = app.variantSummary(p);

    final tenures = kTenures.where((t) => t <= p.maxTenure).toList();
    final selTenure = app.selectedTenure(p);
    final minMonthly = price / tenures.last;
    final plansCollapsed = app.plansCollapsed(p);
    final selectedMonthly = price / selTenure;
    final selectedForImage = p.imageVariantType != null
        ? app.selectedVariant(p, p.imageVariantType!)
        : null;
    final currentImageSource = p.variantImageUrl(selectedForImage) ?? p.image;

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
                  Text(
                    'Pay using 1Fi',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product card with brand pill overlaying the image.
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surface,
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: c.surfaceTint,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              p.brand,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: c.text),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 168,
                            width: double.infinity,
                            child: ProductImage(
                              product: p,
                              selectedColor: selectedForImage,
                              iconSize: 66,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          onTap: () => shareProduct(
                            p,
                            imageSource: currentImageSource,
                          ),
                        ),
                      ],
                    ),
                    if (vSummary.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          vSummary,
                          style: TextStyle(fontSize: 12.5, color: c.text2),
                        ),
                      ),
                    const SizedBox(height: 22),
                    // Amount card.
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: c.surface,
                        border: Border.all(color: c.border),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUGGESTED AMOUNT',
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: c.text2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rupees(price),
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: c.text),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () =>
                                context.read<AppState>().togglePlansCollapsed(p),
                            child: Container(
                              padding: const EdgeInsets.only(top: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: c.border)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                          fontSize: 13, color: c.text),
                                      children: [
                                        const TextSpan(text: 'Starts at '),
                                        TextSpan(
                                          text: '${rupees(minMonthly)}/mo',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        plansCollapsed
                                            ? 'Show plans'
                                            : 'Hide plans',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: c.accent500),
                                      ),
                                      const SizedBox(width: 4),
                                      AnimatedRotation(
                                        turns: plansCollapsed ? 0.5 : 0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 15,
                                            color: c.accent500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!plansCollapsed)
                            ...tenures.map((t) {
                              final sel = t == selTenure;
                              final monthly = price / t;
                              return InkWell(
                                onTap: () => context
                                    .read<AppState>()
                                    .selectTenure(p, t),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: c.border)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: sel
                                                ? c.accent500
                                                : c.border,
                                            width: 2,
                                          ),
                                        ),
                                        child: sel
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(2.5),
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: c.accent500,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$t months',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: c.text)),
                                            Text('No-Cost EMI',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: c.text2)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${rupees(monthly)}/mo',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              sel ? c.accent600 : c.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'PAYING TO',
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: c.text2),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              color: c.accent50, shape: BoxShape.circle),
                          child: Icon(Icons.storefront_outlined,
                              size: 20, color: c.accent500),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('1Fi Marketplace',
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: c.text)),
                            Text('Verified merchant · Instant EMI activation',
                                style: TextStyle(
                                    fontSize: 12, color: c.text2)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CtaBar(
              label: 'Selected plan',
              amountText: '${rupees(selectedMonthly)}/mo × $selTenure mo',
              buttonText: 'Proceed to pay',
              onPressed: () => showEmiConfirmSheet(
                context,
                productName: p.name,
                variantSummary: vSummary,
                tenure: selTenure,
                monthly: selectedMonthly.round(),
                total: price,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
