import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/cards/order_card.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<OrderStatus?> _statusFilters = const [
    null, // All
    OrderStatus.processing,
    OrderStatus.shipped,
    OrderStatus.delivered,
    OrderStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Orders',
        showBackButton: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Processing'),
            Tab(text: 'Shipped'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: _statusFilters.map((status) {
            final orders = orderProvider.getFilteredOrders(status);

            if (orders.isEmpty) {
              return EmptyStateWidget(
                title: 'No Orders Found',
                description: status == null
                    ? 'You have not placed any orders yet.'
                    : 'No orders with status ${status.name}.',
                icon: Icons.receipt_long_outlined,
                buttonText: 'Shop Now',
                onButtonPressed: () => context.go('/home'),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  onTap: () => context.push('/order-details/${order.id}'),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
