import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../products/models/product_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  OrderProvider() {
    debugPrint('[ORDER PROVIDER] 📦 Initializing OrderProvider...');
    // Initial mock order for demo
    _orders.add(
      OrderModel(
        id: 'ORD-8921-X',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        items: const [
          CartItemModel(
            product: ProductModel(
              id: 'p_1',
              title: 'RimRid Wireless ANC Headphones',
              brand: 'RimRid Sound',
              category: 'Electronics',
              price: 149.99,
              rating: 4.8,
              reviewCount: 245,
              images: ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80'],
              description: 'Wireless Headphones',
            ),
            quantity: 1,
            selectedColor: 'Matte Black',
          ),
        ],
        subtotal: 149.99,
        tax: 12.00,
        shippingFee: 0.0,
        discount: 15.00,
        totalAmount: 146.99,
        status: OrderStatus.shipped,
        shippingAddress: '742 Evergreen Terrace, Springfield, OR 97477',
        paymentMethod: 'Credit Card (•••• 4242)',
      ),
    );
  }

  List<OrderModel> getFilteredOrders(OrderStatus? statusFilter) {
    debugPrint('[ORDER PROVIDER] 🔍 Filtering orders by status: ${statusFilter?.name ?? 'All'}');
    if (statusFilter == null) return _orders;
    return _orders.where((o) => o.status == statusFilter).toList();
  }

  OrderModel? getOrderById(String id) {
    debugPrint('[ORDER PROVIDER] 🔍 Fetching Order details for ID: $id');
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  OrderModel createOrder({
    required List<CartItemModel> items,
    required double subtotal,
    required double tax,
    required double shippingFee,
    required double discount,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
  }) {
    final orderId = 'ORD-${(1000 + _orders.length + 1)}-${DateTime.now().millisecond}';
    debugPrint('[ORDER PROVIDER] 🛍️ Creating new order: $orderId for total amount: \$$totalAmount');

    final newOrder = OrderModel(
      id: orderId,
      orderDate: DateTime.now(),
      items: List.from(items),
      subtotal: subtotal,
      tax: tax,
      shippingFee: shippingFee,
      discount: discount,
      totalAmount: totalAmount,
      status: OrderStatus.processing,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, newOrder);
    debugPrint('[ORDER PROVIDER] 🎉 Order $orderId created successfully! Active order count: ${_orders.length}');
    notifyListeners();
    return newOrder;
  }
}
