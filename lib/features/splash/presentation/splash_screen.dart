import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../auth/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _showLogo = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  Future<void> _startAnimation() async {
    setState(() => _showLogo = true);

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _showFooter = true);

    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    final isLoggedIn = ref.read(authStateProvider).value != null;
    context.go(isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedOpacity(
                  opacity: _showLogo ? 1 : 0,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  child: AnimatedScale(
                    scale: _showLogo ? 1 : 0.85,
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    child: FractionallySizedBox(
                      widthFactor: context.isTablet ? 0.28 : 0.42,
                      child: Image.asset(AppAssets.logo),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spaceXl),
              child: AnimatedOpacity(
                opacity: _showFooter ? 1 : 0,
                duration: AppConstants.animMedium,
                curve: Curves.easeOutCubic,
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    children: const [
                      TextSpan(text: 'Powered by Oyelabs '),
                      TextSpan(
                        text: 'WITH LOVE ❤',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
