import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ApiService {
  /// Defaults to the public Vercel deployment (api/products.js, backed by
  /// Neon) — works out of the box on any device or platform with no local
  /// server needed.
  ///
  /// Pass `--dart-define=API_BASE_URL=http://<host>:4000` to point at a
  /// local `server.js` instead while iterating on backend changes: use
  /// `10.0.2.2` for an Android emulator, `localhost` for iOS
  /// simulator/macOS/web/desktop, or the Mac's LAN IP (or `adb reverse
  /// tcp:4000 tcp:4000` + `localhost`) for a physical device over
  /// USB/Wi-Fi, since neither `localhost` nor `10.0.2.2` reach the host
  /// machine from there.
  static const _override = String.fromEnvironment('API_BASE_URL');
  static const _cacheKey = 'cached_products_v1';

  static String get baseUrl {
    if (_override.isNotEmpty) {
      return _override;
    }
    return 'https://app-submission-marketplace.vercel.app';
  }

  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/products'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load products (${res.statusCode})');
    }
    unawaited(_cacheRaw(res.body));
    return _parse(res.body);
  }

  /// The last successfully fetched catalog, read straight from disk — used
  /// to paint the Marketplace instantly on launch instead of a blank
  /// loading state, while [fetchProducts] refreshes it in the background.
  Future<List<Product>?> loadCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;
      return _parse(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheRaw(String body) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, body);
    } catch (_) {
      // Non-fatal — the app just re-fetches over the network next launch.
    }
  }

  List<Product> _parse(String body) {
    final List<dynamic> data = jsonDecode(body) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
