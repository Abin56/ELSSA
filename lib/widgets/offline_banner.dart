import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/text_styles.dart';
import '../core/utils/network_info.dart';

class OfflineBanner extends ConsumerStatefulWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends ConsumerState<OfflineBanner> {
  bool? _wasConnected;
  bool _showReconnected = false;
  Timer? _reconnectedTimer;

  @override
  void dispose() {
    _reconnectedTimer?.cancel();
    super.dispose();
  }

  void _handleConnectivityChange(bool isConnected) {
    if (_wasConnected == false && isConnected) {
      _reconnectedTimer?.cancel();
      setState(() => _showReconnected = true);
      _reconnectedTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showReconnected = false);
      });
    }
    _wasConnected = isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final connectivity = ref.watch(isConnectedProvider);

    connectivity.whenData(_handleConnectivityChange);

    final isConnected = connectivity.value ?? true;
    final showOfflineBar = !isConnected;
    final showBar = showOfflineBar || _showReconnected;

    return Column(
      children: [
        AnimatedSize(
          duration: AppConstants.animMedium,
          curve: Curves.easeOutCubic,
          child: showBar
              ? _BannerContent(isOffline: showOfflineBar)
              : const SizedBox(width: double.infinity),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

class _BannerContent extends StatelessWidget {
  const _BannerContent({required this.isOffline});

  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm,
        ),
        color: isOffline ? AppColors.error : AppColors.success,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
              color: AppColors.white,
              size: 16,
            ),
            const SizedBox(width: AppConstants.spaceSm),
            Text(
              isOffline ? 'You are offline' : 'Back online',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
