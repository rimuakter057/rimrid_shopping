import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final double size;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onPressed: () => onChanged(quantity - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              quantity.toString(),
              style: AppTextStyles.title.copyWith(fontSize: 14),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.radiusSm,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size * 0.5, color: AppColors.textPrimary),
      ),
    );
  }
}
