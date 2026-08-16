import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/formatters.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double priceSize;
  final Color? priceColor;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceSize = 16.0,
    this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasOriginal = originalPrice != null && originalPrice! > price;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            Formatters.currency(price),
            style: AppTextStyles.title.copyWith(
              fontSize: priceSize,
              fontWeight: FontWeight.w700,
              color: priceColor ?? AppColors.textPrimary,
            ),
          ),
          if (hasOriginal) ...[
            const SizedBox(width: 4),
            Text(
              Formatters.currency(originalPrice!),
              style: AppTextStyles.caption.copyWith(
                fontSize: priceSize * 0.75,
                decoration: TextDecoration.lineThrough,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
