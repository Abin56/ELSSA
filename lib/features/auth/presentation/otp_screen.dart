import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/otp_box_field.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/responsive_page.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, this.phoneNumber = ''});

  final String phoneNumber;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _otpLength = 6;

  final _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(_otpLength, (_) => FocusNode());

  bool _showIllustration = false;
  bool _showBoxes = false;
  bool _showButton = false;

  static const _resendCooldownSeconds = 30;
  int _resendCooldown = _resendCooldownSeconds;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _showIllustration = true);
    });
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _showBoxes = true);
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showButton = true);
    });
    _startResendCooldown();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendCooldown = _resendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown -= 1);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerifyOtp() async {
    final smsCode = _controllers.map((c) => c.text).join();
    if (smsCode.length != _otpLength) {
      AppSnackBar.showError(context, 'Please enter the complete OTP.');
      return;
    }

    final notifier = ref.read(authControllerProvider.notifier);
    final success = await notifier.verifyOtp(smsCode);
    if (!mounted) return;

    if (success) {
      final message = ref.read(authControllerProvider).successMessage;
      if (message != null) AppSnackBar.showSuccess(context, message);
      context.push(AppRoutes.location);
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) AppSnackBar.showError(context, error);
    }
  }

  Future<void> _handleResendOtp() async {
    if (_resendCooldown > 0) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .sendOtp(widget.phoneNumber, isResend: true);
    if (!mounted) return;

    if (success) {
      AppSnackBar.showInfo(context, 'OTP resent successfully.');
      _startResendCooldown();
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) AppSnackBar.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: ResponsivePage(
        applyPadding: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedOpacity(
              opacity: _showIllustration ? 1 : 0,
              duration: AppConstants.animMedium,
              curve: Curves.easeOutCubic,
              child: AspectRatio(
                aspectRatio: 626 / 626,
                child: Image.asset(
                  AppAssets.otpIllustration,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'OTP Verification',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  _buildSubtitle(),
                  const SizedBox(height: AppConstants.spaceXl),
                  _buildOtpRow(context),
                  const SizedBox(height: AppConstants.spaceLg),
                  Center(
                    child: GestureDetector(
                      onTap: (isLoading || _resendCooldown > 0)
                          ? null
                          : _handleResendOtp,
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'OTP not received? '),
                            TextSpan(
                              text: _resendCooldown > 0
                                  ? 'RESEND IN ${_resendCooldown}S'
                                  : 'RESEND OTP',
                              style: _resendCooldown > 0
                                  ? AppTextStyles.link.copyWith(
                                      color: AppColors.textHint,
                                    )
                                  : AppTextStyles.link,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceXl),
                  AnimatedOpacity(
                    opacity: _showButton ? 1 : 0,
                    duration: AppConstants.animMedium,
                    curve: Curves.easeOutCubic,
                    child: PrimaryButton(
                      label: 'VERIFY & PROCEED',
                      onPressed: isLoading ? null : _handleVerifyOtp,
                      isLoading: isLoading,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        children: [
          const TextSpan(text: 'Enter the OTP sent to '),
          TextSpan(
            text: widget.phoneNumber,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpRow(BuildContext context) {
    final availableWidth = context.maxContentWidth.isFinite
        ? context.maxContentWidth
        : MediaQuery.sizeOf(context).width;
    final rowWidth = availableWidth - (context.horizontalPadding * 2);
    final boxSize =
        ((rowWidth - (_otpLength - 1) * AppConstants.spaceSm) / _otpLength)
            .clamp(40.0, 52.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, (index) {
        return AnimatedOpacity(
          opacity: _showBoxes ? 1 : 0,
          duration: AppConstants.animMedium,
          curve: Curves.easeOutCubic,
          child: OtpBoxField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            autofocus: index == 0,
            size: boxSize,
            previousFocusNode: index > 0 ? _focusNodes[index - 1] : null,
            nextFocusNode: index < _otpLength - 1
                ? _focusNodes[index + 1]
                : null,
          ),
        );
      }),
    );
  }
}
