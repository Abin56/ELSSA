import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../widgets/country.dart';
import '../../../widgets/phone_input_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/responsive_page.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _phoneController = TextEditingController();
  Country _selectedCountry = kCountries.first;
  bool _showIllustration = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _showIllustration = true);
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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
      body: ResponsivePage(
        applyPadding: false,
        scrollable: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildIllustration()),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.horizontalPadding,
                AppConstants.spaceLg,
                context.horizontalPadding,
                AppConstants.spaceMd,
              ),
              child: AnimatedOpacity(
                opacity: _showContent ? 1 : 0,
                duration: AppConstants.animMedium,
                curve: Curves.easeOutCubic,
                child: _buildContent(authState.isLoading),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return AnimatedSlide(
      offset: _showIllustration ? Offset.zero : const Offset(0, -0.08),
      duration: AppConstants.animMedium,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _showIllustration ? 1 : 0,
        duration: AppConstants.animMedium,
        curve: Curves.easeOutCubic,
        child: SizedBox.expand(
          child: Image.asset(
            AppAssets.loginIllustration,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isLoading) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Home services Expert',
          textAlign: TextAlign.center,
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppConstants.spaceXs),
        Text(
          'Continue with Phone Number',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
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
          label: 'SIGN UP',
          onPressed: isLoading ? null : _handleSendOtp,
          isLoading: isLoading,
          backgroundColor: AppColors.black,
          borderRadius: AppConstants.radiusPill,
        ),
        const SizedBox(height: AppConstants.spaceMd),
        TextButton(
          onPressed: () => context.push(AppRoutes.login),
          child: Text('VIEW OTHER OPTION', style: AppTextStyles.link),
        ),
        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              children: [
                const TextSpan(text: 'ALREADY HAVE AN ACCOUNT? '),
                TextSpan(
                  text: 'LOG IN',
                  style: AppTextStyles.link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
