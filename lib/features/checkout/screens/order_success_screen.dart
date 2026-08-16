import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_button.dart';
import '../../../core/widgets/buttons/custom_outlined_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: AppColors.success,
                  ),
                ),
                AppSpacing.verticalXl,
                Text(
                  'Order Placed Successfully!',
                  style: AppTextStyles.display.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Thank you for your purchase. Your order number is:',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    orderId,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
                AppSpacing.verticalLg,
                Text(
                  'We have sent the confirmation details to your email. You can track your order status live in your account.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalXl,

                CustomButton(
                  title: 'View Order Details',
                  onPressed: () => context.go('/order-details/$orderId'),
                ),
                AppSpacing.verticalMd,

                CustomOutlinedButton(
                  title: 'Continue Shopping',
                  onPressed: () => context.go('/home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
