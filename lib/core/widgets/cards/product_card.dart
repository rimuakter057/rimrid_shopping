import 'package:flutter/material.dart';
import '../../../features/products/models/product_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../common/discount_badge.dart';
import '../common/price_widget.dart';
import '../common/product_image.dart';
import '../common/rating_widget.dart';
import '../common/wishlist_button.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onWishlistTap;
  final bool isWishlisted;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    required this.onWishlistTap,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {

    // final String? nullableDemoText = null;
    // final String titleForDemo = nullableDemoText!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusLg,
          boxShadow: AppShadows.cardShadowList,
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Badges
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                      child: ProductImage(imageUrl: product.images.first),
                    ),
                  ),
                  // Wishlist Button Top Right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: WishlistButton(
                      isWishlisted: isWishlisted,
                      onTap: onWishlistTap,
                    ),
                  ),
                  // Discount Badge Top Left
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: DiscountBadge(discountPercentage: product.discountPercentage),
                    ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: AppSpacing.paddingMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  RatingWidget(rating: product.rating, reviewCount: product.reviewCount),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PriceWidget(
                          price: product.price,
                          originalPrice: product.originalPrice,
                          priceSize: 15,
                        ),
                      ),
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: AppRadius.radiusSm,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: AppRadius.radiusSm,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
