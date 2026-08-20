class ProductModel {
  final String id;
  final String title;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String description;
  final bool isFeatured;
  final bool isTrending;
  final bool isFlashSale;
  final List<String> sizes;
  final List<String> colors;
  final int stockCount;

  const ProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.description,
    this.isFeatured = false,
    this.isTrending = false,
    this.isFlashSale = false,
    this.sizes = const [],
    this.colors = const [],
    this.stockCount = 10,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'images': images,
      'description': description,
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isFlashSale': isFlashSale,
      'sizes': sizes,
      'colors': colors,
      'stockCount': stockCount,
    };
  }

  factory ProductModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
      description: json['description'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isFlashSale: json['isFlashSale'] ?? false,
      sizes: (json['sizes'] as List? ?? []).map((e) => e.toString()).toList(),
      colors: (json['colors'] as List? ?? []).map((e) => e.toString()).toList(),
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 10,
    );
  }
}
