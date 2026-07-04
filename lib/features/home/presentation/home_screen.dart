import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/custom_bottom_navigation.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/secondary_button.dart';
import '../../auth/providers/auth_provider.dart';
import 'home_body.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;
  bool _showNav = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showNav = true);
    });
  }

  Future<void> _handleBackPress() async {
    final action = await showDialog<_ExitDialogAction>(
      context: context,
      builder: (context) => const _ExitConfirmationDialog(),
    );

    if (!mounted || action == null) return;

    if (action == _ExitDialogAction.exit) {
      SystemNavigator.pop();
    } else if (action == _ExitDialogAction.logout) {
      await ref.read(authControllerProvider.notifier).signOut();
      if (mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: const HomeBody(),
            ),
          ),
        ),
        bottomNavigationBar: AnimatedSlide(
          offset: _showNav ? Offset.zero : const Offset(0, 0.3),
          duration: AppConstants.animMedium,
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _showNav ? 1 : 0,
            duration: AppConstants.animMedium,
            curve: Curves.easeOutCubic,
            child: CustomBottomNavigation(
              currentIndex: _navIndex,
              onChanged: (index) => setState(() => _navIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ExitDialogAction { exit, logout }

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Leaving so soon?',
              textAlign: TextAlign.center,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            Text(
              'Exit the app or log out of your account.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spaceLg),
            PrimaryButton(
              label: 'EXIT APP',
              onPressed: () =>
                  Navigator.of(context).pop(_ExitDialogAction.exit),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            SecondaryButton(
              label: 'LOG OUT',
              onPressed: () =>
                  Navigator.of(context).pop(_ExitDialogAction.logout),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL', style: AppTextStyles.link),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
