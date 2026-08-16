import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../../products/models/product_model.dart';
import '../../../core/constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String _appliedPromoCode = '';
  double _discountAmount = 0.0;

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  String get appliedPromoCode => _appliedPromoCode;
  double get discountAmount => _discountAmount;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee =>
      subtotal >= AppConstants.freeShippingThreshold || subtotal == 0
          ? 0.0
          : AppConstants.flatShippingFee;

  double get tax => subtotal * AppConstants.defaultTaxRate;

  double get total => (subtotal + tax + shippingFee - _discountAmount).clamp(0.0, double.infinity);

  void addToCart(ProductModel product, {int quantity = 1, String? size, String? color}) {
    debugPrint('[CART PROVIDER] 🛒 Adding to cart: "${product.title}" x $quantity (Size: $size, Color: $color)');
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex >= 0) {
      final currentItem = _items[existingIndex];
      _items[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + quantity,
      );
      debugPrint('[CART PROVIDER] 📈 Incremented quantity for existing item. New qty: ${_items[existingIndex].quantity}');
    } else {
      _items.add(CartItemModel(
        product: product,
        quantity: quantity,
        selectedSize: size ?? (product.sizes.isNotEmpty ? product.sizes.first : null),
        selectedColor: color ?? (product.colors.isNotEmpty ? product.colors.first : null),
      ));
      debugPrint('[CART PROVIDER] ➕ Added new item to cart. Total items in cart: ${_items.length}');
    }
    debugPrint('[CART PROVIDER] 💰 Updated Subtotal: \$$subtotal | Total: \$$total');
    notifyListeners();
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    debugPrint('[CART PROVIDER] 🔄 Updating quantity for "${item.product.title}" to $newQuantity');
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }
    final index = _items.indexOf(item);
    if (index >= 0) {
      _items[index] = item.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  void removeFromCart(CartItemModel item) {
    debugPrint('[CART PROVIDER] 🗑️ Removing item "${item.product.title}" from cart');
    _items.remove(item);
    if (_items.isEmpty) {
      _appliedPromoCode = '';
      _discountAmount = 0.0;
    }
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    debugPrint('[CART PROVIDER] 🏷️ Validating promo code: "$code"');
    if (code.trim().toUpperCase() == 'RIMRID15') {
      _appliedPromoCode = 'RIMRID15';
      _discountAmount = AppConstants.defaultPromoDiscount;
      debugPrint('[CART PROVIDER] ✅ Promo Code "RIMRID15" applied! Discount: -\$$_discountAmount');
      notifyListeners();
      return true;
    }
    debugPrint('[CART PROVIDER] ❌ Invalid promo code attempt');
    return false;
  }

  void removePromoCode() {
    debugPrint('[CART PROVIDER] 🗑️ Removed promo code');
    _appliedPromoCode = '';
    _discountAmount = 0.0;
    notifyListeners();
  }

  void clearCart() {
    debugPrint('[CART PROVIDER] 🧹 Clearing cart...');
    _items.clear();
    _appliedPromoCode = '';
    _discountAmount = 0.0;
    notifyListeners();
  }
}
