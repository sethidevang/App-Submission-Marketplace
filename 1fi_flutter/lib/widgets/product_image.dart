import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/context_ext.dart';
import '../theme/tokens.dart';

/// Renders a product's photo over its brand gradient, falling back to the
/// category icon if no image is available or it fails to load.
///
/// Prefers the network photo for [selectedColor] (from that color option's
/// own image, e.g. a retailer CDN URL) when present, then [Product.image]
/// — which may itself be a network URL or a bundled asset filename — then
/// the category icon.
class ProductImage extends StatelessWidget {
  final Product product;
  final String? selectedColor;
  final double iconSize;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.product,
    this.selectedColor,
    this.iconSize = 44,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final variantUrl = product.variantImageUrl(selectedColor);
    final baseIsUrl = product.image.startsWith('http');
    final networkUrl = variantUrl ?? (baseIsUrl ? product.image : null);
    final hasImage = networkUrl != null || product.image.isNotEmpty;

    Widget content;
    if (networkUrl != null) {
      content = Image.network(
        networkUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: c.text3,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _iconFallback(c),
      );
    } else if (product.image.isNotEmpty) {
      content = Image.asset(
        'assets/products/${product.image}',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _iconFallback(c),
      );
    } else {
      content = _iconFallback(c);
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: hasImage ? c.surface : null,
          gradient: hasImage
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    hexToColor(product.grad[0]),
                    hexToColor(product.grad[1]),
                  ],
                ),
        ),
        child: hasImage
            ? Padding(padding: const EdgeInsets.all(10), child: content)
            : content,
      ),
    );
  }

  Widget _iconFallback(AppColors c) {
    return Center(
      child: Icon(iconForProduct(product.icon), size: iconSize, color: c.text3),
    );
  }
}
