import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/app_logger.dart';
import '../models/product_model.dart';
import 'product_repository.dart';
import '../../categories/models/category_model.dart';
import '../../home/models/banner_model.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection or server error.']);
  @override
  String toString() => message;
}

class ApiProductRepository implements ProductRepository {
  static const String _baseUrl = 'https://dummyjson.com';

  @override
  Future<List<ProductModel>> getProducts() async {
    const url = '$_baseUrl/products?limit=30';
    AppLogger.logApiRequest(method: 'GET', url: url);

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['products'] ?? [];
        AppLogger.logApiResponse(
          statusCode: response.statusCode,
          url: url,
          summary: 'Successfully fetched ${productsJson.length} products from Free API',
        );
        return productsJson.map((jsonItem) => _parseProduct(jsonItem)).toList();
      } else {
        AppLogger.logApiResponse(statusCode: response.statusCode, url: url, summary: 'HTTP Server Error');
        throw NetworkException('Failed to load products (HTTP ${response.statusCode})');
      }
    } catch (e) {
      AppLogger.logApiError(url: url, error: e);
      throw NetworkException('Unable to reach server. Please check your internet connection.');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    const url = '$_baseUrl/products/categories';
    AppLogger.logApiRequest(method: 'GET', url: url);

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        AppLogger.logApiResponse(
          statusCode: response.statusCode,
          url: url,
          summary: 'Successfully fetched ${data.length} categories from Free API',
        );

        final List<CategoryModel> categories = [];
        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          String name = '';
          String slug = '';

          if (item is String) {
            name = item.replaceAll('-', ' ').toUpperCase();
            slug = item;
          } else if (item is Map) {
            name = (item['name'] ?? item['slug'] ?? 'Category').toString().replaceAll('-', ' ').toUpperCase();
            slug = (item['slug'] ?? 'category').toString();
          }

          categories.add(
            CategoryModel(
              id: 'api_cat_$i',
              name: _capitalizeWords(name),
              imageUrl: _getCategoryImage(slug, i),
              itemCount: 15 + (i * 7) % 40,
              slug: slug,
            ),
          );
        }
        return categories;
      } else {
        AppLogger.logApiResponse(statusCode: response.statusCode, url: url, summary: 'HTTP Categories Error');
        throw NetworkException('Failed to load categories (HTTP ${response.statusCode})');
      }
    } catch (e) {
      AppLogger.logApiError(url: url, error: e);
      throw NetworkException('Unable to load categories. Please check network connection.');
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    AppLogger.logEvent('PROMO BANNERS', 'Loading featured promo banners...');
    return const [
      BannerModel(
        id: 'banner_1',
        title: 'Summer Collection 2026',
        subtitle: 'Up to 50% Off Top Brands',
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1000&q=80',
        buttonText: 'Shop Sale',
        categoryFilter: 'Beauty',
      ),
      BannerModel(
        id: 'banner_2',
        title: 'Next-Gen Smart Electronics',
        subtitle: 'Discover Latest Wireless Gadgets',
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1000&q=80',
        buttonText: 'Explore Tech',
        categoryFilter: 'Beauty',
      ),
    ];
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final url = '$_baseUrl/products/$id';
    AppLogger.logApiRequest(method: 'GET', url: url);

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        AppLogger.logApiResponse(statusCode: 200, url: url, summary: 'Product details fetched');
        return _parseProduct(data);
      }
    } catch (e) {
      AppLogger.logApiError(url: url, error: e);
      throw NetworkException('Failed to load product details.');
    }
    return null;
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final url = '$_baseUrl/products/search?q=${Uri.encodeComponent(query)}';
    AppLogger.logApiRequest(method: 'GET', url: url);

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['products'] ?? [];
        AppLogger.logApiResponse(statusCode: 200, url: url, summary: 'Found ${productsJson.length} search results');
        return productsJson.map((j) => _parseProduct(j)).toList();
      }
    } catch (e) {
      AppLogger.logApiError(url: url, error: e);
      throw NetworkException('Search failed due to network issues.');
    }
    return [];
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final slug = category.toLowerCase().replaceAll(' ', '-');
    final url = '$_baseUrl/products/category/$slug';
    AppLogger.logApiRequest(method: 'GET', url: url);

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List productsJson = data['products'] ?? [];
        AppLogger.logApiResponse(statusCode: 200, url: url, summary: 'Category items loaded');
        return productsJson.map((j) => _parseProduct(j)).toList();
      }
    } catch (e) {
      AppLogger.logApiError(url: url, error: e);
      throw NetworkException('Category items fetch error.');
    }
    return [];
  }

  ProductModel _parseProduct(Map<String, dynamic> j) {
    final double price = (j['price'] as num?)?.toDouble() ?? 0.0;
    final double discount = (j['discountPercentage'] as num?)?.toDouble() ?? 0.0;
    final double originalPrice = discount > 0 ? price / (1 - (discount / 100)) : price;

    List<String> imagesList = [];
    if (j['images'] != null && j['images'] is List) {
      imagesList = (j['images'] as List).map((e) => e.toString()).toList();
    }
    if (imagesList.isEmpty && j['thumbnail'] != null) {
      imagesList = [j['thumbnail'].toString()];
    }

    return ProductModel(
      id: (j['id'] ?? '0').toString(),
      title: j['title'] ?? 'Product',
      brand: j['brand'] ?? 'RimRid Select',
      category: _capitalizeWords((j['category'] ?? 'General').toString().replaceAll('-', ' ')),
      price: double.parse(price.toStringAsFixed(2)),
      originalPrice: discount > 0 ? double.parse(originalPrice.toStringAsFixed(2)) : null,
      rating: (j['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: 20 + ((j['id'] as int? ?? 1) * 13) % 150,
      images: imagesList,
      description: j['description'] ?? 'Premium product from RimRid Shopping.',
      isFeatured: (j['id'] as int? ?? 0) % 3 == 0,
      isFlashSale: discount > 10,
      isTrending: (j['rating'] as num? ?? 0) >= 4.5,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Default', 'Black', 'White'],
      stockCount: (j['stock'] as int?) ?? 15,
    );
  }

  String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _getCategoryImage(String slug, int index) {
    final categoryImages = [
      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=400&q=80',
    ];
    return categoryImages[index % categoryImages.length];
  }
}
