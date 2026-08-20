import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/buttons/custom_button.dart';
import '../../../core/widgets/fields/custom_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final String? prefillUsername;

  const LoginScreen({super.key, this.prefillUsername});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final justSignedUp = widget.prefillUsername != null;
    _emailController = TextEditingController(text: widget.prefillUsername ?? 'emilys');
    _passwordController = TextEditingController(text: justSignedUp ? '' : 'emilyspass');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      if (success) {
        AppHelpers.showSnackBar(context, 'Welcome back, ${authProvider.currentUser?.name}!', isSuccess: true);
        context.go('/home');
      } else {
        AppHelpers.showSnackBar(
          context,
          authProvider.errorMessage ?? 'Login failed. Please try again.',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.horizontalPadding(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Icon & Title
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    AppSpacing.verticalLg,
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.display.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to access your RimRid Shopping profile',
                      style: AppTextStyles.bodyMedium,
                    ),
                    AppSpacing.verticalXl,

                    // Username Field
                    CustomTextField(
                      label: 'Username',
                      hint: 'e.g. emilys',
                      controller: _emailController,
                      keyboardType: TextInputType.text,
                      validator: (val) => Validators.validateRequired(val, 'Username'),
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                    ),
                    AppSpacing.verticalLg,

                    // Password Field
                    CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: Validators.validatePassword,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Demo login: emilys / emilyspass (DummyJSON test user)',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),

                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          AppHelpers.showSnackBar(
                            context,
                            'Password reset link sent to ${_emailController.text}',
                            isSuccess: true,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.verticalLg,

                    // Sign In Button
                    CustomButton(
                      title: 'Sign In',
                      isLoading: authProvider.isLoading,
                      onPressed: _handleLogin,
                    ),

                    AppSpacing.verticalLg,

                    // Guest / Demo Login Button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          authProvider.loginAsGuest();
                          context.go('/home');
                        },
                        child: Text(
                          'Continue as Guest',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    AppSpacing.verticalLg,

                    // Footer Link to Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: AppTextStyles.bodyMedium),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
