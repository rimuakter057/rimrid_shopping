import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/common/custom_app_bar.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'App Settings',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Notifications
              Text('Notifications', style: AppTextStyles.title.copyWith(fontSize: 16)),
              AppSpacing.verticalSm,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: settingsProvider.pushNotifications,
                      activeColor: AppColors.primary,
                      onChanged: (val) => settingsProvider.togglePushNotifications(val),
                      title: Text('Push Notifications', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      subtitle: Text('Receive instant order updates & flash sale alerts', style: AppTextStyles.caption),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: settingsProvider.emailPromotions,
                      activeColor: AppColors.primary,
                      onChanged: (val) => settingsProvider.toggleEmailPromotions(val),
                      title: Text('Email Newsletter & Deals', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      subtitle: Text('Get weekly exclusive promo codes in your inbox', style: AppTextStyles.caption),
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalXl,

              // Section 2: Currency Preference
              Text('Regional Preferences', style: AppTextStyles.title.copyWith(fontSize: 16)),
              AppSpacing.verticalSm,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: ListTile(
                  title: Text('Display Currency', style: AppTextStyles.title.copyWith(fontSize: 14)),
                  subtitle: Text(settingsProvider.selectedCurrency, style: AppTextStyles.caption),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Select Currency', style: AppTextStyles.title),
                            const SizedBox(height: 16),
                            ListTile(
                              title: const Text('USD (\$)'),
                              onTap: () {
                                settingsProvider.setCurrency('USD (\$)');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('EUR (€)'),
                              onTap: () {
                                settingsProvider.setCurrency('EUR (€)');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('GBP (£)'),
                              onTap: () {
                                settingsProvider.setCurrency('GBP (£)');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              AppSpacing.verticalXl,

              // Section 3: App Information
              Text('About Application', style: AppTextStyles.title.copyWith(fontSize: 16)),
              AppSpacing.verticalSm,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.radiusLg,
                  boxShadow: AppShadows.softShadowList,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('App Version', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      trailing: Text('v1.0.0+1', style: AppTextStyles.bodyMedium),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text('Privacy Policy & Terms', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.textMuted),
                      onTap: () {
                        AppHelpers.showSnackBar(context, 'RimRid Privacy Policy & Terms of Service loaded');
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: Text('Developer', style: AppTextStyles.title.copyWith(fontSize: 14)),
                      trailing: Text(AppConstants.appName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
