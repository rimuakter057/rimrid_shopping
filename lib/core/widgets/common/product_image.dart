import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: AppColors.shimmerBase,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.primaryLight,
          child: const Center(
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}
