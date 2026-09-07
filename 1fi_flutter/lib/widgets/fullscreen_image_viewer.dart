import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/tokens.dart';

/// Full-bleed, pinch-to-zoom preview of a product's current photo, opened
/// by tapping the image on the detail screen. Dismiss with the close button
/// (top-right) or by swiping/tapping back.
class FullscreenImageViewer extends StatelessWidget {
  final Product product;
  final String? selectedColor;

  const FullscreenImageViewer({
    super.key,
    required this.product,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final source = product.variantImageUrl(selectedColor) ?? product.image;
    final isUrl = source.startsWith('http');

    Widget content;
    if (source.isEmpty) {
      content = Icon(iconForProduct(product.icon),
          size: 96, color: Colors.white24);
    } else {
      content = isUrl
          ? Image.network(
              source,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                  iconForProduct(product.icon),
                  size: 96,
                  color: Colors.white24),
            )
          : Image.asset(
              'assets/products/$source',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                  iconForProduct(product.icon),
                  size: 96,
                  color: Colors.white24),
            );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(child: content),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.close_rounded,
                        size: 22, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
