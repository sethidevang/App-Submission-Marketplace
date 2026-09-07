class VariantOption {
  final String label;
  final int delta;
  final String? hex;

  VariantOption({required this.label, required this.delta, this.hex});

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
      label: json['label'] as String,
      delta: (json['delta'] as num?)?.toInt() ?? 0,
      hex: json['hex'] as String?,
    );
  }
}

class ProductVariant {
  final String type;
  final List<VariantOption> options;

  ProductVariant({required this.type, required this.options});

  bool get isColor => type == 'Color';

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      type: json['type'] as String,
      options: (json['options'] as List)
          .map((o) => VariantOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Product {
  final String id;
  final String brand;
  final String name;
  final String category;
  final String icon;
  final List<String> grad;
  final int price;
  final int mrp;
  final int maxTenure;
  final double rating;
  final String reviews;
  final List<ProductVariant> variants;
  final List<String> highlights;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.category,
    required this.icon,
    required this.grad,
    required this.price,
    required this.mrp,
    required this.maxTenure,
    required this.rating,
    required this.reviews,
    required this.variants,
    required this.highlights,
  });

  int get discountPct {
    if (mrp <= price) return 0;
    return (100 * (1 - price / mrp)).round();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      grad: (json['grad'] as List).map((e) => e as String).toList(),
      price: (json['price'] as num).toInt(),
      mrp: (json['mrp'] as num).toInt(),
      maxTenure: (json['maxTenure'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as String,
      variants: (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
          .toList(),
      highlights:
          (json['highlights'] as List).map((e) => e as String).toList(),
    );
  }
}
