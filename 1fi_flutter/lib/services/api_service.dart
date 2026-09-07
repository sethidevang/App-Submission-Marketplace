import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class ApiService {
  /// The Express server from the web prototype (server.js) serves this API,
  /// backed by the local Postgres `1fi` database.
  ///
  /// Android emulators can't reach the host machine via `localhost`, so they
  /// use the special alias `10.0.2.2` instead. Every other target (iOS
  /// simulator, macOS, web, desktop) talks to `localhost` directly.
  /// (`defaultTargetPlatform` is used instead of `dart:io`'s `Platform` so
  /// this file still compiles for Flutter web.)
  ///
  /// A physical device (real iPhone/Android over wifi) is on its own network
  /// namespace, so neither `localhost` nor `10.0.2.2` reach the host Mac —
  /// pass the Mac's LAN IP via `--dart-define=API_BASE_URL=http://<ip>:4000`
  /// when running on one.
  static const _override = String.fromEnvironment('API_BASE_URL');
  static const _cacheKey = 'cached_products_v1';

  static String get baseUrl {
    if (_override.isNotEmpty) {
      return _override;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000';
    }
    return 'http://localhost:4000';
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
