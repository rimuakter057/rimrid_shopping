import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/cards/category_card.dart';
import '../../../core/widgets/cards/product_card.dart';
import '../../../core/widgets/common/no_internet_widget.dart';
import '../../../core/widgets/common/product_grid.dart';
import '../../../core/widgets/common/section_header.dart';
import '../../../core/widgets/fields/search_field.dart';
import '../../../core/widgets/loaders/loading_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../products/providers/product_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    if (productProvider.isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Connecting to RimRid API...'),
      );
    }

    if (productProvider.hasNetworkError) {
      return Scaffold(
        body: NoInternetWidget(
          message: productProvider.errorMessage,
          onRetry: () => productProvider.loadData(),
        ),
      );
    }

    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => productProvider.refreshData(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Top Header with User Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${user?.name ?? 'Shopper'} 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Welcome to RimRid Shopping',
                          style: AppTextStyles.title.copyWith(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'What are you looking for today?',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                    child: user?.avatarUrl == null
                        ? const Icon(Icons.person_outline_rounded, color: AppColors.primary)
                        : null,
                  ),
                ],
              ),

                AppSpacing.verticalLg,

                // Search Bar Trigger
                SearchField(
                  readOnly: true,
                  onTap: () => context.push('/search'),
                ),

                AppSpacing.verticalXl,

                // Promotional Banner Slider
                if (productProvider.banners.isNotEmpty) ...[
                  SizedBox(
                    height: ResponsiveHelper.valueByDevice(
                      context: context,
                      mobile: AppDimensions.bannerHeightMobile,
                      tablet: AppDimensions.bannerHeightTablet,
                    ),
                    child: PageView.builder(
                      itemCount: productProvider.banners.length,
                      itemBuilder: (context, index) {
                        final banner = productProvider.banners[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.radiusXl,
                            image: DecorationImage(
                              image: NetworkImage(banner.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.radiusXl,
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.black.withOpacity(0.75),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner.title,
                                  style: AppTextStyles.title.copyWith(
                                    color: AppColors.textWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner.subtitle,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textWhite.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.surface,
                                    foregroundColor: AppColors.textPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
                                  ),
                                  onPressed: () {
                                    productProvider.selectCategory(banner.categoryFilter);
                                    context.push('/products');
                                  },
                                  child: Text(
                                    banner.buttonText,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AppSpacing.verticalXl,
                ],

                // Categories Section Header
                SectionHeader(
                  title: 'Categories',
                  actionTitle: 'See All',
                  onActionTap: () => context.push('/categories'),
                ),
                AppSpacing.verticalMd,

                // Categories Horizontal List
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final cat = productProvider.categories[index];
                      return CategoryCard(
                        category: cat,
                        isSelected: productProvider.selectedCategory == cat.name,
                        onTap: () {
                          productProvider.selectCategory(cat.name);
                          context.push('/products');
                        },
                      );
                    },
                  ),
                ),

                AppSpacing.verticalXl,

                // Flash Sale Section Header
                SectionHeader(
                  title: '⚡ Flash Sale',
                  actionTitle: 'View All',
                  onActionTap: () {
                    productProvider.selectCategory('All');
                    context.push('/products');
                  },
                ),
                AppSpacing.verticalMd,

                // Flash Sale Horizontal List
                if (productProvider.flashSaleProducts.isNotEmpty)
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.flashSaleProducts.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.flashSaleProducts[index];
                        return Container(
                          width: 170,
                          margin: const EdgeInsets.only(right: 14),
                          child: ProductCard(
                            product: product,
                            isWishlisted: wishlistProvider.isWishlisted(product.id),
                            onTap: () => context.push('/product/${product.id}'),
                            onAddToCart: () {
                              cartProvider.addToCart(product);
                              AppHelpers.showSnackBar(context, '${product.title} added to cart', isSuccess: true);
                            },
                            onWishlistTap: () => wishlistProvider.toggleWishlist(product),
                          ),
                        );
                      },
                    ),
                  ),

                AppSpacing.verticalXl,

                // Featured Products Section Header
                SectionHeader(
                  title: 'Featured Collection',
                  actionTitle: 'Explore',
                  onActionTap: () => context.push('/products'),
                ),
                AppSpacing.verticalMd,

                // Featured Product Grid using LayoutBuilder
                ProductGrid(
                  products: productProvider.featuredProducts,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  isWishlisted: wishlistProvider.isWishlisted,
                  onProductTap: (product) => context.push('/product/${product.id}'),
                  onAddToCart: (product) {
                    cartProvider.addToCart(product);
                    AppHelpers.showSnackBar(context, '${product.title} added to cart', isSuccess: true);
                  },
                  onWishlistTap: (product) => wishlistProvider.toggleWishlist(product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
