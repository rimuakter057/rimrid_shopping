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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signup(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      if (success) {
        final username = _emailController.text.trim().split('@').first;
        AppHelpers.showSnackBar(context, 'Account created! Please sign in.', isSuccess: true);
        context.go('/login', extra: username);
      } else {
        AppHelpers.showSnackBar(
          context,
          authProvider.errorMessage ?? 'Signup failed. Please try again.',
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: AppTextStyles.display.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Join RimRid Shopping to start your fashion journey',
                      style: AppTextStyles.bodyMedium,
                    ),
                    AppSpacing.verticalXl,

                    // Full Name Field
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'Alex Rimrid',
                      controller: _nameController,
                      validator: (val) => Validators.validateRequired(val, 'Full Name'),
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                    ),
                    AppSpacing.verticalLg,

                    // Email Field
                    CustomTextField(
                      label: 'Email Address',
                      hint: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    ),
                    AppSpacing.verticalLg,

                    // Password Field
                    CustomTextField(
                      label: 'Password',
                      hint: 'At least 6 characters',
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
                    AppSpacing.verticalLg,

                    // Confirm Password Field
                    CustomTextField(
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      validator: (val) => Validators.validateConfirmPassword(val, _passwordController.text),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                    ),

                    AppSpacing.verticalXl,

                    // Sign Up Button
                    CustomButton(
                      title: 'Create Account',
                      isLoading: authProvider.isLoading,
                      onPressed: _handleSignup,
                    ),

                    AppSpacing.verticalLg,

                    // Footer Link to Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?', style: AppTextStyles.bodyMedium),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Sign In',
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
