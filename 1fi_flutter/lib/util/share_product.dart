import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product.dart';
import 'format.dart';

/// Shares a product's photo alongside a link back to it in the 1Fi
/// Marketplace. [imageSource] is whatever is currently on screen — a
/// network URL (retailer CDN) or a bundled asset filename — so the shared
/// photo matches the selected variant, not just the product's default.
/// Falls back to a text-only share if the image can't be fetched.
Future<void> shareProduct(Product product, {String? imageSource}) async {
  final text =
      'Check out ${product.name} on 1Fi Marketplace — ${rupees(product.price)} '
      'with No-Cost EMI.\nhttps://1fi.app/marketplace/${product.id}';

  final source = imageSource ?? product.image;
  if (source.isEmpty) {
    await Share.share(text);
    return;
  }

  try {
    final List<int> bytes;
    final isUrl = source.startsWith('http');
    if (isUrl) {
      final response = await http.get(Uri.parse(source));
      if (response.statusCode != 200) throw Exception('image fetch failed');
      bytes = response.bodyBytes;
    } else {
      final data = await rootBundle.load('assets/products/$source');
      bytes = data.buffer.asUint8List();
    }

    final ext = source.toLowerCase().contains('.png') ? 'png' : 'jpg';
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/share_${product.id}.$ext');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path)], text: text);
  } catch (_) {
    await Share.share(text);
  }
}
