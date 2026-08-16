import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/custom_button.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const NoInternetWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: AppColors.error,
              ),
            ),
            AppSpacing.verticalXl,
            Text(
              'No Internet Connection',
              style: AppTextStyles.title.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Please check your Wi-Fi or Mobile Data connection and try again.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalXl,
            CustomButton(
              title: 'Retry Connection',
              icon: Icons.refresh_rounded,
              width: 200,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
