import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../products/models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _wishlistItems = [];

  List<ProductModel> get wishlistItems => List.unmodifiable(_wishlistItems);
  int get count => _wishlistItems.length;

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
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    debugPrint('[WISHLIST PROVIDER] 🗑️ Removed product ID $productId from wishlist');
    _wishlistItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearWishlist() {
    debugPrint('[WISHLIST PROVIDER] 🧹 Cleared entire wishlist');
    _wishlistItems.clear();
    notifyListeners();
  }
}
