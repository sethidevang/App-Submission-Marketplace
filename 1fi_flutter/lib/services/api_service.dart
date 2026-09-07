import 'dart:convert';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;

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
    final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
