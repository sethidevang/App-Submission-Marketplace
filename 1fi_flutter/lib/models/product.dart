class VariantOption {
  final String label;
  final int delta;
  final String? hex;
  final String? image;

  VariantOption({
    required this.label,
    required this.delta,
    this.hex,
    this.image,
  });

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
      label: json['label'] as String,
      delta: (json['delta'] as num?)?.toInt() ?? 0,
      hex: json['hex'] as String?,
      image: json['image'] as String?,
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
  final String image;
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
    required this.image,
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

  /// The first variant axis (Color, Size, Storage, ...) whose options carry
  /// their own photos, whichever type that happens to be — a TV's images
  /// might live on its "Size" options, a phone's on its "Color" options.
  ProductVariant? get _imageVariant {
    for (final v in variants) {
      if (v.options.any((o) => o.image != null && o.image!.isNotEmpty)) {
        return v;
      }
    }
    return null;
  }

  /// The type name of [_imageVariant] (e.g. `'Color'`, `'Size'`), or null if
  /// no variant axis on this product carries photos. Screens use this to
  /// know which variant selection to read before calling [variantImageUrl].
  String? get imageVariantType => _imageVariant?.type;

  /// The network photo for [selectedValue] of [imageVariantType] (or the
  /// first option when none is selected yet), if that option has one. Null
  /// means fall back to the bundled/base [image].
  String? variantImageUrl(String? selectedValue) {
    final variant = _imageVariant;
    if (variant == null || variant.options.isEmpty) return null;
    final option = selectedValue == null
        ? variant.options.first
        : variant.options.firstWhere(
            (o) => o.label == selectedValue,
            orElse: () => variant.options.first,
          );
    return (option.image != null && option.image!.isNotEmpty)
        ? option.image
        : null;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      brand: json['brand'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String? ?? '',
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
