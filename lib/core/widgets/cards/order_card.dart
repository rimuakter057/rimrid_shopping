import 'package:flutter/material.dart';
import '../../../features/orders/models/order_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../common/order_status_badge.dart';
import '../common/price_widget.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusLg,
          boxShadow: AppShadows.softShadowList,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: AppTextStyles.title.copyWith(fontSize: 15, color: AppColors.primary),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Date: ${Formatters.formatDate(order.orderDate)}',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} ${order.items.length == 1 ? 'Item' : 'Items'}',
                  style: AppTextStyles.bodyMedium,
                ),
                Row(
                  children: [
                    Text('Total: ', style: AppTextStyles.bodyMedium),
                    PriceWidget(price: order.totalAmount, priceSize: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
