import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_shadows.dart';

class WishlistButton extends StatelessWidget {
  final bool isWishlisted;
  final VoidCallback onTap;
  final double size;

  const WishlistButton({
    super.key,
    required this.isWishlisted,
    required this.onTap,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.softShadowList,
        ),
        child: Icon(
          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isWishlisted ? AppColors.wishlistActive : AppColors.textMuted,
          size: size * 0.55,
        ),
      ),
    );
  }
}
