import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/buttons/custom_button.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/discount_badge.dart';
import '../../../core/widgets/common/price_widget.dart';
import '../../../core/widgets/common/product_image.dart';
import '../../../core/widgets/common/quantity_selector.dart';
import '../../../core/widgets/common/rating_widget.dart';
import '../../../core/widgets/common/wishlist_button.dart';
import '../../../core/widgets/loaders/error_widget.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final product = productProvider.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Product Details'),
        body: CustomErrorWidget(
          message: 'Product not found.',
          onRetry: () => context.pop(),
        ),
      );
    }

    _selectedSize ??= product.sizes.isNotEmpty ? product.sizes.first : null;
    _selectedColor ??= product.colors.isNotEmpty ? product.colors.first : null;
    final isWishlisted = wishlistProvider.isWishlisted(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: product.brand,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: WishlistButton(
              isWishlisted: isWishlisted,
              onTap: () => wishlistProvider.toggleWishlist(product),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Image Carousel Display
                    Container(
                      height: 320,
                      width: double.infinity,
                      color: AppColors.surface,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: product.images.length,
                            onPageChanged: (idx) => setState(() => _selectedImageIndex = idx),
                            itemBuilder: (context, index) {
                              return ProductImage(
                                imageUrl: product.images[index],
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                          if (product.hasDiscount)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: DiscountBadge(discountPercentage: product.discountPercentage),
                            ),
                        ],
                      ),
                    ),

                    // Thumbnail indicators
                    if (product.images.length > 1) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.length,
                          (idx) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _selectedImageIndex == idx ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _selectedImageIndex == idx ? AppColors.primary : AppColors.border,
                              borderRadius: AppRadius.radiusFull,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Details Section
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.title,
                                  style: AppTextStyles.heading.copyWith(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              RatingWidget(rating: product.rating, reviewCount: product.reviewCount),
                              const SizedBox(width: 12),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${product.stockCount} in stock',
                                style: AppTextStyles.caption.copyWith(
                                  color: product.stockCount > 0 ? AppColors.success : AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          PriceWidget(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            priceSize: 24,
                          ),

                          const Divider(height: 32),

                          // Colors Selection
                          if (product.colors.isNotEmpty) ...[
                            Text('Select Color', style: AppTextStyles.title.copyWith(fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: product.colors.map((c) {
                                final isSelected = _selectedColor == c;
                                return ChoiceChip(
                                  label: Text(c),
                                  selected: isSelected,
                                  selectedColor: AppColors.primaryLight,
                                  backgroundColor: AppColors.surface,
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  onSelected: (val) => setState(() => _selectedColor = c),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Sizes Selection
                          if (product.sizes.isNotEmpty) ...[
                            Text('Select Size', style: AppTextStyles.title.copyWith(fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: product.sizes.map((s) {
                                final isSelected = _selectedSize == s;
                                return ChoiceChip(
                                  label: Text(s),
                                  selected: isSelected,
                                  selectedColor: AppColors.primaryLight,
                                  backgroundColor: AppColors.surface,
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  onSelected: (val) => setState(() => _selectedSize = s),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Description
                          Text('Description', style: AppTextStyles.title.copyWith(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 24),

                          // Quantity Selection
                          Row(
                            children: [
                              Text('Quantity:', style: AppTextStyles.title.copyWith(fontSize: 15)),
                              const SizedBox(width: 16),
                              QuantitySelector(
                                quantity: _quantity,
                                onChanged: (q) {
                                  if (q >= 1) setState(() => _quantity = q);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Persistent Bottom Add to Cart Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.bottomNavShadowList,
              ),
              child: CustomButton(
                title: 'Add to Cart • \$${(product.price * _quantity).toStringAsFixed(2)}',
                icon: Icons.shopping_bag_outlined,
                onPressed: () {
                  cartProvider.addToCart(
                    product,
                    quantity: _quantity,
                    size: _selectedSize,
                    color: _selectedColor,
                  );
                  AppHelpers.showSnackBar(
                    context,
                    'Added $_quantity x ${product.title} to cart',
                    isSuccess: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
