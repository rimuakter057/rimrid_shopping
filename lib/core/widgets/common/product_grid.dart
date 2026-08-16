import 'package:flutter/material.dart';
import '../../../features/products/models/product_model.dart';
import '../../responsive/responsive_helper.dart';
import '../../theme/app_spacing.dart';
import '../cards/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onAddToCart;
  final Function(ProductModel) onWishlistTap;
  final bool Function(String productId) isWishlisted;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onAddToCart,
    required this.onWishlistTap,
    required this.isWishlisted,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.gridColumns(context);
        return GridView.builder(
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 0.68,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              isWishlisted: isWishlisted(product.id),
              onTap: () => onProductTap(product),
              onAddToCart: () => onAddToCart(product),
              onWishlistTap: () => onWishlistTap(product),
            );
          },
        );
      },
    );
  }
}
