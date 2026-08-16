import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_button.dart';
import '../../auth/providers/auth_provider.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'Discover Trendy Fashion',
      description: 'Explore thousands of curated luxury products from global top brands in one place.',
      icon: Icons.checkroom_rounded,
    ),
    OnboardingPage(
      title: 'Fast & Secure Checkout',
      description: 'Enjoy seamless online shopping with multiple secure payment methods and instant order tracking.',
      icon: Icons.local_shipping_rounded,
    ),
    OnboardingPage(
      title: 'Express Doorstep Delivery',
      description: 'Get your orders delivered right to your doorstep with guaranteed quality and easy returns.',
      icon: Icons.mark_unread_chat_alt_rounded,
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.completeOnboarding();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              // Top Bar Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 72,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSpacing.verticalXl,
                        Text(
                          page.title,
                          style: AppTextStyles.display.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalMd,
                        Text(
                          page.description,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Page Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? AppColors.primary : AppColors.border,
                      borderRadius: AppRadius.radiusFull,
                    ),
                  ),
                ),
              ),

              AppSpacing.verticalLg,

              // Bottom CTA
              CustomButton(
                title: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _onNext,
              ),

              AppSpacing.verticalLg,
            ],
          ),
        ),
      ),
    );
  }
}
