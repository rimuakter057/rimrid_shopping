import 'package:flutter/material.dart';
import '../../../features/orders/models/order_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;

    switch (status) {
      case OrderStatus.processing:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        bg = AppColors.successLight;
        fg = AppColors.success;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        bg = AppColors.errorLight;
        fg = AppColors.error;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
