import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/order_status_badge.dart';
import '../../../core/widgets/common/price_widget.dart';
import '../../../core/widgets/common/product_image.dart';
import '../../../core/widgets/loaders/error_widget.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Order Details'),
        body: CustomErrorWidget(
          message: 'Order #$orderId not found.',
          onRetry: () => context.pop(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Order ${order.id}',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID: ${order.id}', style: AppTextStyles.title.copyWith(fontSize: 15)),
                        OrderStatusBadge(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Placed on ${Formatters.formatDateTime(order.orderDate)}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const Divider(height: 24),
                    _buildTrackingTimeline(order.status),
                  ],
                ),
              ),

              AppSpacing.verticalXl,

              // Purchased Items List
              Text('Purchased Items (${order.items.length})', style: AppTextStyles.title.copyWith(fontSize: 16)),
              AppSpacing.verticalSm,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Container(
                    padding: AppSpacing.paddingMd,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.radiusLg,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: AppRadius.radiusMd,
                            child: ProductImage(imageUrl: item.product.images.first),
                          ),
                        ),
                        AppSpacing.horizontalMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.title.copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Qty: ${item.quantity}  ${item.selectedColor != null ? '• Color: ${item.selectedColor}' : ''}',
                                style: AppTextStyles.caption,
                              ),
                              const SizedBox(height: 4),
                              PriceWidget(price: item.totalPrice, priceSize: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              AppSpacing.verticalXl,

              // Delivery & Payment Info
              Text('Delivery & Payment', style: AppTextStyles.title.copyWith(fontSize: 16)),
              AppSpacing.verticalSm,
              Container(
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address:', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(order.shippingAddress, style: AppTextStyles.bodyMedium),
                    const Divider(height: 24),
                    Text('Payment Method:', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(order.paymentMethod, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),

              AppSpacing.verticalXl,

              // Cost Summary
              Container(
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: AppShadows.softShadowList,
                ),
                child: Column(
                  children: [
                    _buildCostRow('Subtotal', Formatters.currency(order.subtotal)),
                    _buildCostRow('Tax', Formatters.currency(order.tax)),
                    _buildCostRow('Shipping', order.shippingFee == 0 ? 'FREE' : Formatters.currency(order.shippingFee)),
                    if (order.discount > 0)
                      _buildCostRow('Discount', '-${Formatters.currency(order.discount)}', isHighlight: true),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount Paid', style: AppTextStyles.title),
                        PriceWidget(price: order.totalAmount, priceSize: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline(OrderStatus status) {
    int currentStep = 1;
    if (status == OrderStatus.shipped) currentStep = 2;
    if (status == OrderStatus.delivered) currentStep = 3;
    if (status == OrderStatus.cancelled) currentStep = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTimelineStep(1, 'Placed', currentStep >= 1),
        _buildTimelineStep(2, 'Shipped', currentStep >= 2),
        _buildTimelineStep(3, 'Delivered', currentStep >= 3),
      ],
    );
  }

  Widget _buildTimelineStep(int stepIndex, String title, bool isCompleted) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isCompleted ? AppColors.primary : AppColors.border,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            size: 14,
            color: isCompleted ? AppColors.textWhite : AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow(String title, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlight ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
