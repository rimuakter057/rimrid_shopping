import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/avatar_helper.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../../../core/widgets/common/custom_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Account Profile',
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
          child: Column(
            children: [
              // User Info Header Card
              Container(
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: AvatarHelper.resolve(user?.avatarUrl),
                      child: AvatarHelper.resolve(user?.avatarUrl) == null
                          ? const Icon(Icons.person_rounded, size: 36, color: AppColors.primary)
                          : null,
                    ),
                    AppSpacing.horizontalLg,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Alex Rimrid',
                            style: AppTextStyles.title.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'alex.rimrid@example.com',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.phone ?? '+1 (555) 234-5678',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalXl,

              // Profile Navigation Menu
              _buildMenuCard(
                context,
                children: [
                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    subtitle: 'Track live status and order history',
                    onTap: () => context.push('/orders'),
                  ),
                  const Divider(),
                  _buildMenuItem(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Wishlist',
                    subtitle: 'View saved favorite items',
                    onTap: () => context.push('/wishlist'),
                  ),
                  const Divider(),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    subtitle: profileProvider.selectedAddress,
                    onTap: () {
                      AppHelpers.showSnackBar(context, 'Primary Address: ${profileProvider.selectedAddress}');
                    },
                  ),
                  const Divider(),
                  _buildMenuItem(
                    icon: Icons.payment_rounded,
                    title: 'Payment Methods',
                    subtitle: profileProvider.selectedPaymentMethod,
                    onTap: () {
                      AppHelpers.showSnackBar(context, 'Default Payment: ${profileProvider.selectedPaymentMethod}');
                    },
                  ),
                ],
              ),

              AppSpacing.verticalLg,

              _buildMenuCard(
                context,
                children: [
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    subtitle: 'Notifications, currency, and privacy',
                    onTap: () => context.push('/settings'),
                  ),
                  const Divider(),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Customer Support',
                    subtitle: AppConstants.supportEmail,
                    onTap: () {
                      AppHelpers.showSnackBar(context, 'Support Hotline: ${AppConstants.supportPhone}');
                    },
                  ),
                ],
              ),

              AppSpacing.verticalXl,

              // Logout Button
              _buildMenuCard(
                context,
                children: [
                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.error,
                    title: 'Log Out',
                    titleColor: AppColors.error,
                    showArrow: false,
                    onTap: () {
                      CustomDialog.show(
                        context,
                        title: 'Log Out',
                        message: 'Are you sure you want to log out of RimRid Shopping?',
                        confirmText: 'Log Out',
                        cancelText: 'Cancel',
                        icon: Icons.logout_rounded,
                        onConfirm: () {
                          authProvider.logout();
                          context.go('/login');
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        boxShadow: AppShadows.softShadowList,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: AppTextStyles.title.copyWith(fontSize: 15, color: titleColor ?? AppColors.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            )
          : null,
      trailing: showArrow ? const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted) : null,
    );
  }
}
