import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../models/product_model.dart';
import '../repositories/api_product_repository.dart';
import '../repositories/product_repository.dart';
import '../../categories/models/category_model.dart';
import '../../home/models/banner_model.dart';

enum ProductSortOption { popular, priceLowToHigh, priceHighToLow, rating }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<BannerModel> _banners = [];
  bool _isLoading = false;
  bool _hasNetworkError = false;
  String _errorMessage = '';
  String _selectedCategory = 'All';
  String _searchQuery = '';
  ProductSortOption _sortOption = ProductSortOption.popular;

  ProductProvider({ProductRepository? repository})
      : _repository = repository ?? ApiProductRepository() {
    AppLogger.logEvent('PRODUCT PROVIDER', '🚀 Initializing ProductProvider...');
    loadData();
  }

  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  bool get hasNetworkError => _hasNetworkError;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  ProductSortOption get sortOption => _sortOption;

  List<ProductModel> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  List<ProductModel> get flashSaleProducts =>
      _products.where((p) => p.isFlashSale).toList();

  List<ProductModel> get trendingProducts =>
      _products.where((p) => p.isTrending).toList();

  List<ProductModel> get filteredProducts {
    List<ProductModel> result = List.from(_products);

    // Filter by category
    if (_selectedCategory != 'All') {
      result = result
          .where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }

    // Apply Sorting
    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.popular:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    return result;
  }

  Future<void> loadData() async {
    _isLoading = true;
    _hasNetworkError = false;
    _errorMessage = '';
    notifyListeners();
    AppLogger.logEvent('PRODUCT PROVIDER', '📦 Fetching catalog data from API...');

    try {
      _products = await _repository.getProducts();
      _categories = await _repository.getCategories();
      _banners = await _repository.getBanners();

      AppLogger.logEvent('PRODUCT PROVIDER', '✅ Data load success: ${_products.length} products & ${_categories.length} categories!');
      _hasNetworkError = false;
    } catch (e) {
      _hasNetworkError = true;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      AppLogger.logEvent('PRODUCT PROVIDER', '❌ Failed to load API data: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    AppLogger.logEvent('PRODUCT PROVIDER', '🔄 Pull-to-Refresh triggered! Re-fetching catalog...');
    await loadData();
  }

  void selectCategory(String category) {
    AppLogger.logEvent('PRODUCT PROVIDER', '🏷️ Selected Category changed to: "$category"');
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    AppLogger.logEvent('PRODUCT PROVIDER', '🔍 Search Query set to: "$query"');
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    AppLogger.logEvent('PRODUCT PROVIDER', '🔀 Sort Option set to: ${option.name}');
    _sortOption = option;
    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    AppLogger.logEvent('PRODUCT PROVIDER', '🔍 Looking up Product ID: "$id"');
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
