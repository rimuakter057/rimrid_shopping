import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/common/custom_chip.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../../../core/widgets/common/product_grid.dart';
import '../../../core/widgets/fields/search_field.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _popularTags = const [
    'Headphones',
    'Sneakers',
    'Watch',
    'Hoodie',
    'Serum',
    'Bag',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final results = productProvider.filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            productProvider.setSearchQuery('');
            context.pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SearchField(
            controller: _controller,
            onChanged: (q) => productProvider.setSearchQuery(q),
            onClear: () => productProvider.setSearchQuery(''),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Popular Search Tags
            if (_controller.text.isEmpty) ...[
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Popular Searches', style: AppTextStyles.title.copyWith(fontSize: 15)),
                    AppSpacing.verticalSm,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _popularTags.map((tag) {
                        return CustomChip(
                          label: tag,
                          isSelected: productProvider.searchQuery == tag,
                          onTap: () {
                            _controller.text = tag;
                            productProvider.setSearchQuery(tag);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],

            // Search Results List Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
              child: Row(
                children: [
                  Text(
                    _controller.text.isEmpty
                        ? 'All Products (${results.length})'
                        : 'Search Results for "${_controller.text}" (${results.length})',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Products Grid
            Expanded(
              child: results.isEmpty
                  ? EmptyStateWidget(
                      title: 'No Matching Products',
                      description: 'Try searching for another keyword or browse our categories.',
                      icon: Icons.search_off_rounded,
                      buttonText: 'Clear Search',
                      onButtonPressed: () {
                        _controller.clear();
                        productProvider.setSearchQuery('');
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: ProductGrid(
                        products: results,
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
    );
  }
}
