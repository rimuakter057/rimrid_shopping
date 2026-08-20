import '../../products/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItemModel({
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }

  factory CartItemModel.fromJson(Map<dynamic, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      selectedSize: json['selectedSize'] as String?,
      selectedColor: json['selectedColor'] as String?,
    );
  }
}
