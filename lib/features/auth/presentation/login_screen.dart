import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../widgets/country.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/facebook_logo.dart';
import '../../../widgets/google_logo.dart';
import '../../../widgets/phone_input_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/responsive_page.dart';
import '../../../widgets/social_login_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  Country _selectedCountry = kCountries.first;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final notifier = ref.read(authControllerProvider.notifier);
    final success = await notifier.signInWithGoogle();
    if (!mounted) return;

    if (success) {
      final message = ref.read(authControllerProvider).successMessage;
      if (message != null) AppSnackBar.showSuccess(context, message);
      context.go(AppRoutes.location);
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) AppSnackBar.showError(context, error);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    final notifier = ref.read(authControllerProvider.notifier);
    final success = await notifier.signInWithFacebook();
    if (!mounted) return;

    if (success) {
      final message = ref.read(authControllerProvider).successMessage;
      if (message != null) AppSnackBar.showSuccess(context, message);
      context.go(AppRoutes.location);
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) AppSnackBar.showError(context, error);
    }
  }

  Future<void> _handleSendOtp() async {
    final number = _phoneController.text.trim();
    if (number.isEmpty) {
      AppSnackBar.showError(context, 'Please enter your phone number.');
      return;
    }

    final phone = '${_selectedCountry.dialCode}$number';
    final notifier = ref.read(authControllerProvider.notifier);
    final success = await notifier.sendOtp(phone);
    if (!mounted) return;

    if (success && notifier.isAutoVerified) {
      context.go(AppRoutes.location);
    } else if (success) {
      context.push(AppRoutes.otp, extra: phone);
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) AppSnackBar.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: ResponsivePage(
        child: AnimatedOpacity(
          opacity: _showContent ? 1 : 0,
          duration: AppConstants.animMedium,
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: _showContent ? Offset.zero : const Offset(0, 0.05),
            duration: AppConstants.animMedium,
            curve: Curves.easeOutCubic,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: AppConstants.spaceXl),
                SocialLoginButton(
                  label: 'CONTINUE WITH FACEBOOK',
                  icon: const FacebookLogo(size: 20),
                  backgroundColor: const Color.fromARGB(255, 117, 131, 202),
                  textColor: AppColors.white,
                  onPressed: authState.isLoading ? null : _handleFacebookSignIn,
                ),
                const SizedBox(height: AppConstants.spaceMd),
                SocialLoginButton(
                  label: 'CONTINUE WITH GOOGLE',
                  icon: const GoogleLogo(size: 20),
                  onPressed: authState.isLoading ? null : _handleGoogleSignIn,
                ),
                const SizedBox(height: AppConstants.spaceLg),
                _buildDivider(),
                const SizedBox(height: AppConstants.spaceLg),
                PhoneInputField(
                  controller: _phoneController,
                  borderRadius: AppConstants.radiusPill,
                  onCountryChanged: (country) {
                    setState(() => _selectedCountry = country);
                  },
                ),
                const SizedBox(height: AppConstants.spaceLg),
                PrimaryButton(
                  label: 'LOG IN',
                  onPressed: authState.isLoading ? null : _handleSendOtp,
                  isLoading: authState.isLoading,
                  backgroundColor: AppColors.black,
                  borderRadius: AppConstants.radiusPill,
                ),
                const SizedBox(height: AppConstants.spaceMd),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spaceXl),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: "DON'T HAVE AN ACCOUNT? "),
                        TextSpan(
                          text: 'SIGN UP',
                          style: AppTextStyles.link,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push(AppRoutes.signup),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceSm,
            ),
            child: Text(
              'OR CONTINUE WITH PHONE NUMBER',
              style: AppTextStyles.caption.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
