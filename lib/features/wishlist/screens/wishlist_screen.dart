import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/empty_state_widget.dart';
import '../../../core/widgets/common/product_grid.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final items = wishlistProvider.wishlistItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Saved Items (${items.length})',
      ),
      body: SafeArea(
        child: items.isEmpty
            ? EmptyStateWidget(
                title: 'Your Wishlist is Empty',
                description: 'Explore products and tap the heart icon to save your favorite items here.',
                icon: Icons.favorite_border_rounded,
                buttonText: 'Discover Products',
                onButtonPressed: () => context.go('/home'),
              )
            : Padding(
                padding: EdgeInsets.all(padding),
                child: ProductGrid(
                  products: items,
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
    );
  }
}
