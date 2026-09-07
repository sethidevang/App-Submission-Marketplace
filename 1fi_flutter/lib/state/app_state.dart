import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

enum ProductsStatus { loading, ready, error }

const List<String> kCategories = [
  'All',
  'Mobiles',
  'Laptops',
  'TV & Audio',
  'Wearables',
  'Appliances',
];

const List<int> kTenures = [3, 6, 9, 12, 18, 24];

/// Central app state: theme, the product catalog (fetched from Postgres via
/// the Express API), and per-product variant/tenure selections. Mirrors the
/// `state` object in the web prototype's shop-page.html.
class AppState extends ChangeNotifier {
  final ApiService _api = ApiService();

  ThemeMode themeMode = ThemeMode.light;

  List<Product> products = [];
  ProductsStatus status = ProductsStatus.loading;

  String category = 'All';
  String query = '';

  final Map<String, Map<String, String>> _variantSel = {};
  final Map<String, int> _tenureSel = {};
  final Map<String, bool> _plansCollapsed = {};

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    status = ProductsStatus.loading;
    notifyListeners();
    try {
      products = await _api.fetchProducts();
      status = ProductsStatus.ready;
    } catch (_) {
      status = ProductsStatus.error;
    }
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final q = query.trim().toLowerCase();
    return products.where((p) {
      final catOk = category == 'All' || p.category == category;
      final qOk = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q);
      return catOk && qOk;
    }).toList();
  }

  void setCategory(String c) {
    category = c;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void _ensureDefaults(Product p) {
    _variantSel.putIfAbsent(p.id, () {
      final sel = <String, String>{};
      for (final v in p.variants) {
        sel[v.type] = v.options.first.label;
      }
      return sel;
    });
    _tenureSel.putIfAbsent(p.id, () {
      final tenures = kTenures.where((t) => t <= p.maxTenure).toList();
      return tenures.last;
    });
  }

  String selectedVariant(Product p, String type) {
    _ensureDefaults(p);
    return _variantSel[p.id]![type]!;
  }

  void selectVariant(Product p, String type, String value) {
    _ensureDefaults(p);
    _variantSel[p.id]![type] = value;
    notifyListeners();
  }

  int selectedTenure(Product p) {
    _ensureDefaults(p);
    return _tenureSel[p.id]!;
  }

  void selectTenure(Product p, int tenure) {
    _ensureDefaults(p);
    _tenureSel[p.id] = tenure;
    notifyListeners();
  }

  bool plansCollapsed(Product p) => _plansCollapsed[p.id] ?? false;

  void togglePlansCollapsed(Product p) {
    _plansCollapsed[p.id] = !plansCollapsed(p);
    notifyListeners();
  }

  /// The absolute price for one variant option, accounting for the currently
  /// selected options on every *other* axis (e.g. Color's delta while
  /// pricing a Storage row).
  int priceForOption(Product p, String axisType, VariantOption option) {
    _ensureDefaults(p);
    var price = p.price + option.delta;
    for (final v in p.variants) {
      if (v.type == axisType) continue;
      final chosenLabel = _variantSel[p.id]![v.type];
      final chosen = v.options.firstWhere(
        (o) => o.label == chosenLabel,
        orElse: () => v.options.first,
      );
      price += chosen.delta;
    }
    return price;
  }

  int currentPrice(Product p) {
    _ensureDefaults(p);
    var price = p.price;
    for (final v in p.variants) {
      final chosenLabel = _variantSel[p.id]![v.type];
      final chosen = v.options.firstWhere(
        (o) => o.label == chosenLabel,
        orElse: () => v.options.first,
      );
      price += chosen.delta;
    }
    return price;
  }

  String variantSummary(Product p) {
    _ensureDefaults(p);
    return p.variants.map((v) => _variantSel[p.id]![v.type]).join(' · ');
  }
}
