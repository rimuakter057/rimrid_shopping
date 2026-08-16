import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;

  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isDisabled
        ? AppColors.border
        : (backgroundColor ?? AppColors.primary);
    final effectiveFg = textColor ?? AppColors.textWhite;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeightMd,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveFg,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          elevation: 0,
        ),
        onPressed: (isLoading || isDisabled) ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveFg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: effectiveFg),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    title,
                    style: AppTextStyles.button.copyWith(color: effectiveFg),
                  ),
                ],
              ),
      ),
    );
  }
}
