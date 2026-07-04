import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/snackbar_utils.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) return;
    final message = ref.read(authControllerProvider).successMessage;
    if (message != null) AppSnackBar.showSuccess(context, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Profile Screen'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: isLoading ? null : () => _handleLogout(context, ref),
                child: const Text('LOG OUT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
