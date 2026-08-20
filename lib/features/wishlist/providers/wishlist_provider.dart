import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../products/models/product_model.dart';
import '../../../core/services/local_storage_service.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _wishlistItems = [];

  List<ProductModel> get wishlistItems => List.unmodifiable(_wishlistItems);
  int get count => _wishlistItems.length;

  WishlistProvider() {
    debugPrint('[WISHLIST PROVIDER] 📂 Restoring persisted wishlist...');
    final storedItems = LocalStorageService.wishlistBox.get('items') as List?;
    if (storedItems != null) {
      _wishlistItems.addAll(storedItems.map((e) => ProductModel.fromJson(e as Map)));
    }
  }

  void _persist() {
    LocalStorageService.wishlistBox.put('items', _wishlistItems.map((e) => e.toJson()).toList());
  }

  bool isWishlisted(String productId) {
    return _wishlistItems.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    if (isWishlisted(product.id)) {
      debugPrint('[WISHLIST PROVIDER] 💔 Removed from wishlist: "${product.title}"');
      _wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      debugPrint('[WISHLIST PROVIDER] ❤️ Saved to wishlist: "${product.title}"');
      _wishlistItems.add(product);
    }
    _persist();
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    debugPrint('[WISHLIST PROVIDER] 🗑️ Removed product ID $productId from wishlist');
    _wishlistItems.removeWhere((item) => item.id == productId);
    _persist();
    notifyListeners();
  }

  void clearWishlist() {
    debugPrint('[WISHLIST PROVIDER] 🧹 Cleared entire wishlist');
    _wishlistItems.clear();
    _persist();
    notifyListeners();
  }
}
