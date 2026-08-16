import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class DiscountBadge extends StatelessWidget {
  final double discountPercentage;

  const DiscountBadge({
    super.key,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    if (discountPercentage <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.discountTag,
        borderRadius: AppRadius.radiusSm,
      ),
      child: Text(
        '-${discountPercentage.round()}%',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
