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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingFee': shippingFee,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status.name,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromJson(Map<dynamic, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.byName(json['status'] ?? 'processing'),
      shippingAddress: json['shippingAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
    );
  }
}
