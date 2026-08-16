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
}
