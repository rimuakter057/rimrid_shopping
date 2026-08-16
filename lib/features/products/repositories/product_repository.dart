import '../models/product_model.dart';
import '../../categories/models/category_model.dart';
import '../../home/models/banner_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<List<CategoryModel>> getCategories();
  Future<List<BannerModel>> getBanners();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class MockProductRepository implements ProductRepository {
  static const List<CategoryModel> _categories = [
    CategoryModel(
      id: 'cat_1',
      name: 'Electronics',
      imageUrl: 'https://images.unsplash.com/photo-1498049860654-af1a5c566876?auto=format&fit=crop&w=400&q=80',
      itemCount: 45,
      slug: 'electronics',
    ),
    CategoryModel(
      id: 'cat_2',
      name: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=400&q=80',
      itemCount: 88,
      slug: 'fashion',
    ),
    CategoryModel(
      id: 'cat_3',
      name: 'Footwear',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80',
      itemCount: 32,
      slug: 'footwear',
    ),
    CategoryModel(
      id: 'cat_4',
      name: 'Home & Living',
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=400&q=80',
      itemCount: 64,
      slug: 'home_living',
    ),
    CategoryModel(
      id: 'cat_5',
      name: 'Beauty',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=400&q=80',
      itemCount: 29,
      slug: 'beauty',
    ),
    CategoryModel(
      id: 'cat_6',
      name: 'Watches',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80',
      itemCount: 19,
      slug: 'watches',
    ),
  ];

  static const List<BannerModel> _banners = [
    BannerModel(
      id: 'banner_1',
      title: 'Summer Collection',
      subtitle: 'Up to 50% Off Top Brands',
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1000&q=80',
      buttonText: 'Shop Now',
      categoryFilter: 'fashion',
    ),
    BannerModel(
      id: 'banner_2',
      title: 'Smart Gadgets 2026',
      subtitle: 'Discover Next-Gen Technology',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1000&q=80',
      buttonText: 'Explore Tech',
      categoryFilter: 'electronics',
    ),
    BannerModel(
      id: 'banner_3',
      title: 'Premium Footwear',
      subtitle: 'Step into Comfort & Elegance',
      imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80',
      buttonText: 'View Shoes',
      categoryFilter: 'footwear',
    ),
  ];

  static const List<ProductModel> _products = [
    ProductModel(
      id: 'p_1',
      title: 'RimRid Wireless ANC Headphones',
      brand: 'RimRid Sound',
      category: 'Electronics',
      price: 149.99,
      originalPrice: 199.99,
      rating: 4.8,
      reviewCount: 245,
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Experience studio-grade Active Noise Cancellation, 40-hour battery life, ergonomic memory foam earcups, and crystal-clear wireless high-fidelity sound quality.',
      isFeatured: true,
      isFlashSale: true,
      colors: ['Matte Black', 'Silver', 'Navy Blue'],
      stockCount: 15,
    ),
    ProductModel(
      id: 'p_2',
      title: 'Pro Runner Sneaker 2026 Edition',
      brand: 'AeroStep',
      category: 'Footwear',
      price: 89.95,
      originalPrice: 120.00,
      rating: 4.7,
      reviewCount: 189,
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Ultra-lightweight breathable mesh running shoes engineered with maximum cushioning technology for long-distance comfort.',
      isFeatured: true,
      isTrending: true,
      sizes: ['US 8', 'US 9', 'US 10', 'US 11'],
      colors: ['Crimson Red', 'Stealth Black', 'Neon Blue'],
      stockCount: 8,
    ),
    ProductModel(
      id: 'p_3',
      title: 'Minimalist Minimal Chronograph Watch',
      brand: 'ChronoLux',
      category: 'Watches',
      price: 199.00,
      originalPrice: 249.00,
      rating: 4.9,
      reviewCount: 312,
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Genuine Italian leather strap chronograph timepiece with scratch-resistant sapphire crystal glass and 50m water resistance.',
      isFeatured: true,
      colors: ['Rose Gold', 'Silver Black', 'Midnight Blue'],
      stockCount: 5,
    ),
    ProductModel(
      id: 'p_4',
      title: 'Urban Oversized Organic Hoodie',
      brand: 'RimRid Apparel',
      category: 'Fashion',
      price: 59.99,
      originalPrice: 79.99,
      rating: 4.6,
      reviewCount: 142,
      images: [
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?auto=format&fit=crop&w=800&q=80',
      ],
      description: '100% heavy organic fleece cotton streetwear hoodie. Designed for maximum warmth, comfort, and modern minimalist aesthetic.',
      isFlashSale: true,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Sage Green', 'Charcoal', 'Off White'],
      stockCount: 22,
    ),
    ProductModel(
      id: 'p_5',
      title: 'Smart Fitness Tracker Watch Ultra',
      brand: 'PulseFit',
      category: 'Electronics',
      price: 129.50,
      originalPrice: 159.99,
      rating: 4.5,
      reviewCount: 98,
      images: [
        'https://images.unsplash.com/photo-1510017803434-a899398421b3?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Continuous heart-rate monitoring, SpO2 sensor, sleep tracking, Built-in GPS, and 14-day battery life on a single charge.',
      isTrending: true,
      colors: ['Space Gray', 'Starlight', 'Olive Green'],
      stockCount: 12,
    ),
    ProductModel(
      id: 'p_6',
      title: 'Organic Botanical Hydration Serum',
      brand: 'GlowPure',
      category: 'Beauty',
      price: 34.00,
      originalPrice: 45.00,
      rating: 4.9,
      reviewCount: 420,
      images: [
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1608248597263-0057e57b4524?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Pure hyaluronic acid serum enriched with Vitamin C and botanical plant extracts for deep hydration and radiance.',
      isFeatured: true,
      stockCount: 30,
    ),
    ProductModel(
      id: 'p_7',
      title: 'Nordic Ceramic Coffee Set & Tray',
      brand: 'Hygge Home',
      category: 'Home & Living',
      price: 49.99,
      originalPrice: 65.00,
      rating: 4.7,
      reviewCount: 76,
      images: [
        'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1577937927133-66ef06acdf18?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Handcrafted matte ceramic coffee mugs set with bamboo serving tray. Adds elegant Scandinavian charm to your morning routine.',
      isTrending: true,
      colors: ['Matte White', 'Terracotta', 'Basalt Grey'],
      stockCount: 14,
    ),
    ProductModel(
      id: 'p_8',
      title: 'Italian Grain Leather Shoulder Bag',
      brand: 'Vera Moda',
      category: 'Fashion',
      price: 179.00,
      originalPrice: 220.00,
      rating: 4.8,
      reviewCount: 164,
      images: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=800&q=80',
      ],
      description: 'Handstitched full-grain Italian leather purse with custom gold hardware and multi-compartment interior storage.',
      isFeatured: true,
      colors: ['Caramel Brown', 'Classic Black', 'Cream White'],
      stockCount: 9,
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _categories;
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _banners;
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (query.trim().isEmpty) return _products;
    final q = query.toLowerCase();
    return _products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (category.isEmpty || category.toLowerCase() == 'all') {
      return _products;
    }
    return _products.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
