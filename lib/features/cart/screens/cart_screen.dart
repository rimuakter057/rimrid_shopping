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
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/buttons/custom_button.dart';
import '../../../core/widgets/cards/cart_item_card.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/custom_dialog.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../../../core/widgets/common/price_widget.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(
          title: 'Shopping Cart',
          showBackButton: false,
        ),
        body: EmptyStateWidget(
          title: 'Your Cart is Empty',
          description: 'Looks like you haven\'t added any items to your shopping cart yet.',
          icon: Icons.shopping_cart_outlined,
          buttonText: 'Start Shopping',
          onButtonPressed: () => context.go('/home'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Shopping Cart (${cartProvider.itemCount})',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
            onPressed: () {
              CustomDialog.show(
                context,
                title: 'Clear Cart',
                message: 'Are you sure you want to remove all items from your cart?',
                confirmText: 'Clear All',
                cancelText: 'Cancel',
                icon: Icons.delete_forever_rounded,
                onConfirm: () => cartProvider.clearCart(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
                child: Column(
                  children: [
                    // Cart Items List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartProvider.items.length,
                      itemBuilder: (context, index) {
                        final item = cartProvider.items[index];
                        return CartItemCard(
                          item: item,
                          onQuantityChanged: (newQty) => cartProvider.updateQuantity(item, newQty),
                          onRemove: () => cartProvider.removeFromCart(item),
                        );
                      },
                    ),

                    AppSpacing.verticalLg,

                    // Promo Code Box
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.radiusLg,
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: AppShadows.softShadowList,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: AppTextStyles.body,
                              decoration: InputDecoration(
                                hintText: cartProvider.appliedPromoCode.isNotEmpty
                                    ? 'Applied: ${cartProvider.appliedPromoCode}'
                                    : 'Enter Promo Code (Use RIMRID15)',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cartProvider.appliedPromoCode.isNotEmpty
                                  ? AppColors.error
                                  : AppColors.primary,
                              shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () {
                              if (cartProvider.appliedPromoCode.isNotEmpty) {
                                cartProvider.removePromoCode();
                                _promoController.clear();
                                AppHelpers.showSnackBar(context, 'Promo code removed');
                              } else {
                                final success = cartProvider.applyPromoCode(_promoController.text);
                                if (success) {
                                  AppHelpers.showSnackBar(context, 'Promo code RIMRID15 applied! -\$15 OFF', isSuccess: true);
                                } else {
                                  AppHelpers.showSnackBar(context, 'Invalid promo code. Use code RIMRID15', isError: true);
                                }
                              }
                            },
                            child: Text(
                              cartProvider.appliedPromoCode.isNotEmpty ? 'Remove' : 'Apply',
                              style: AppTextStyles.button.copyWith(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.verticalLg,

                    // Order Summary Breakdown Box
                    Container(
                      padding: AppSpacing.paddingLg,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.radiusLg,
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: AppShadows.softShadowList,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Summary', style: AppTextStyles.title.copyWith(fontSize: 16)),
                          const Divider(height: 24),
                          _buildSummaryRow('Subtotal', Formatters.currency(cartProvider.subtotal)),
                          _buildSummaryRow('Estimated Tax (8%)', Formatters.currency(cartProvider.tax)),
                          _buildSummaryRow(
                            'Shipping Fee',
                            cartProvider.shippingFee == 0 ? 'FREE' : Formatters.currency(cartProvider.shippingFee),
                            isHighlight: cartProvider.shippingFee == 0,
                          ),
                          if (cartProvider.discountAmount > 0)
                            _buildSummaryRow(
                              'Discount Code',
                              '-${Formatters.currency(cartProvider.discountAmount)}',
                              isDiscount: true,
                            ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount', style: AppTextStyles.title),
                              PriceWidget(price: cartProvider.total, priceSize: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Persistent Checkout Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.bottomNavShadowList,
              ),
              child: CustomButton(
                title: 'Proceed to Checkout • ${Formatters.currency(cartProvider.total)}',
                onPressed: () => context.push('/checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isDiscount
                  ? AppColors.success
                  : isHighlight
                      ? AppColors.success
                      : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
