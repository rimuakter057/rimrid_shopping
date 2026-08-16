import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/custom_chip.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../../../core/widgets/common/no_internet_widget.dart';
import '../../../core/widgets/common/product_grid.dart';
import '../../../core/widgets/loaders/loading_widget.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  void _showSortModal(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sort Products By', style: AppTextStyles.title),
              const SizedBox(height: 16),
              _buildSortOption(
                context,
                title: 'Most Popular',
                option: ProductSortOption.popular,
                current: provider.sortOption,
                onTap: () {
                  provider.setSortOption(ProductSortOption.popular);
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                context,
                title: 'Price: Low to High',
                option: ProductSortOption.priceLowToHigh,
                current: provider.sortOption,
                onTap: () {
                  provider.setSortOption(ProductSortOption.priceLowToHigh);
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                context,
                title: 'Price: High to Low',
                option: ProductSortOption.priceHighToLow,
                current: provider.sortOption,
                onTap: () {
                  provider.setSortOption(ProductSortOption.priceHighToLow);
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                context,
                title: 'Highest Rated',
                option: ProductSortOption.rating,
                current: provider.sortOption,
                onTap: () {
                  provider.setSortOption(ProductSortOption.rating);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context, {
    required String title,
    required ProductSortOption option,
    required ProductSortOption current,
    required VoidCallback onTap,
  }) {
    final isSelected = option == current;
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    if (productProvider.isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Fetching Product Catalog...'),
      );
    }

    if (productProvider.hasNetworkError) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Product Catalog'),
        body: NoInternetWidget(
          message: productProvider.errorMessage,
          onRetry: () => productProvider.loadData(),
        ),
      );
    }

    final products = productProvider.filteredProducts;
    final categories = ['All', ...productProvider.categories.map((c) => c.name)];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: productProvider.selectedCategory == 'All'
            ? 'All Products'
            : productProvider.selectedCategory,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded, color: AppColors.textPrimary),
            onPressed: () => _showSortModal(context, productProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => productProvider.refreshData(),
          color: AppColors.primary,
          child: Column(
            children: [
              // Category Chips Bar
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return CustomChip(
                      label: cat,
                      isSelected: productProvider.selectedCategory == cat,
                      onTap: () => productProvider.selectCategory(cat),
                    );
                  },
                ),
              ),
              const Divider(height: 1),

              // Item Count Info Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${products.length} Products',
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton.icon(
                      onPressed: () => _showSortModal(context, productProvider),
                      icon: const Icon(Icons.swap_vert_rounded, size: 18, color: AppColors.primary),
                      label: Text(
                        'Sort',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Products Grid
              Expanded(
                child: products.isEmpty
                    ? EmptyStateWidget(
                        title: 'No Products Found',
                        description: 'No products matched your current category or search criteria.',
                        buttonText: 'Reset Filters',
                        onButtonPressed: () => productProvider.selectCategory('All'),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: ProductGrid(
                          products: products,
                          physics: const AlwaysScrollableScrollPhysics(),
                          isWishlisted: wishlistProvider.isWishlisted,
                          onProductTap: (product) => context.push('/product/${product.id}'),
                          onAddToCart: (product) {
                            cartProvider.addToCart(product);
                            AppHelpers.showSnackBar(context, '${product.title} added to cart', isSuccess: true);
                          },
                          onWishlistTap: (product) => wishlistProvider.toggleWishlist(product),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
