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
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/price_widget.dart';
import '../../cart/providers/cart_provider.dart';
import '../../orders/providers/order_provider.dart';
import '../../profile/providers/profile_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentIndex = 0;
  bool _isPlacingOrder = false;

  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, Amex (•••• 4242)',
      'icon': Icons.credit_card_rounded,
    },
    {
      'title': 'Google Pay / Apple Pay',
      'subtitle': 'Fast instant express checkout',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay cash when product arrives',
      'icon': Icons.payments_rounded,
    },
  ];

  Future<void> _handlePlaceOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (cartProvider.isEmpty) {
      AppHelpers.showSnackBar(context, 'Cart is empty', isError: true);
      return;
    }

    setState(() => _isPlacingOrder = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulate payment processing

    final createdOrder = orderProvider.createOrder(
      items: cartProvider.items,
      subtotal: cartProvider.subtotal,
      tax: cartProvider.tax,
      shippingFee: cartProvider.shippingFee,
      discount: cartProvider.discountAmount,
      totalAmount: cartProvider.total,
      shippingAddress: profileProvider.selectedAddress,
      paymentMethod: _paymentMethods[_selectedPaymentIndex]['title'],
    );

    cartProvider.clearCart();

    if (mounted) {
      setState(() => _isPlacingOrder = false);
      context.go('/order-success/${createdOrder.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Checkout'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Shipping Address Box
                    Text('Shipping Address', style: AppTextStyles.title.copyWith(fontSize: 16)),
                    AppSpacing.verticalSm,
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
                          const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 24),
                          AppSpacing.horizontalMd,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Location', style: AppTextStyles.title.copyWith(fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(
                                  profileProvider.selectedAddress,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                            onPressed: () {
                              AppHelpers.showSnackBar(context, 'Default shipping address verified');
                            },
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.verticalXl,

                    // Section 2: Payment Methods Box
                    Text('Payment Method', style: AppTextStyles.title.copyWith(fontSize: 16)),
                    AppSpacing.verticalSm,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _paymentMethods.length,
                      itemBuilder: (context, index) {
                        final method = _paymentMethods[index];
                        final isSelected = _selectedPaymentIndex == index;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.radiusLg,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.borderLight,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: RadioListTile<int>(
                            value: index,
                            groupValue: _selectedPaymentIndex,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _selectedPaymentIndex = val!),
                            title: Text(method['title'], style: AppTextStyles.title.copyWith(fontSize: 14)),
                            subtitle: Text(method['subtitle'], style: AppTextStyles.caption),
                            secondary: Icon(method['icon'], color: isSelected ? AppColors.primary : AppColors.textMuted),
                          ),
                        );
                      },
                    ),

                    AppSpacing.verticalXl,

                    // Section 3: Order Items Quick Preview
                    Text('Order Items (${cartProvider.itemCount})', style: AppTextStyles.title.copyWith(fontSize: 16)),
                    AppSpacing.verticalSm,
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.radiusLg,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                        children: cartProvider.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x  ${item.product.title}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                                  ),
                                ),
                                PriceWidget(price: item.totalPrice, priceSize: 14),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    AppSpacing.verticalXl,

                    // Section 4: Final Total Summary Box
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
                          _buildRow('Subtotal', Formatters.currency(cartProvider.subtotal)),
                          _buildRow('Tax (8%)', Formatters.currency(cartProvider.tax)),
                          _buildRow('Shipping', cartProvider.shippingFee == 0 ? 'FREE' : Formatters.currency(cartProvider.shippingFee)),
                          if (cartProvider.discountAmount > 0)
                            _buildRow('Discount', '-${Formatters.currency(cartProvider.discountAmount)}', isSuccess: true),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Payable', style: AppTextStyles.title),
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

            // Bottom Place Order Action Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.bottomNavShadowList,
              ),
              child: CustomButton(
                title: 'Place Order • ${Formatters.currency(cartProvider.total)}',
                isLoading: _isPlacingOrder,
                onPressed: _handlePlaceOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            val,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isSuccess ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
