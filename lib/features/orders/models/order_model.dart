import '../../cart/models/cart_item_model.dart';

enum OrderStatus { processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final DateTime orderDate;
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double discount;
  final double totalAmount;
  final OrderStatus status;
  final String shippingAddress;
  final String paymentMethod;

  const OrderModel({
    required this.id,
    required this.orderDate,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.discount,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
