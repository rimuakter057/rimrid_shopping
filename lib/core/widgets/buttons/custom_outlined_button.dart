import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? width;

  const CustomOutlinedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.borderColor,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = borderColor ?? AppColors.primary;
    final effectiveText = textColor ?? AppColors.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeightMd,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveText,
          side: BorderSide(color: effectiveBorder, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveText),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: effectiveText),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: AppTextStyles.button.copyWith(color: effectiveText),
                  ),
                ],
              ),
      ),
    );
  }
}
