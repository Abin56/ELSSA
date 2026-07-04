import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/responsive_page.dart';
import '../../../widgets/secondary_button.dart';
import '../models/address_model.dart';
import '../providers/location_error_message.dart';
import '../providers/location_provider.dart';
import '../providers/location_state.dart';
import 'address_search_screen.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  bool _showIllustration = false;
  bool _showButton = false;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _showIllustration = true);
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showButton = true);
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _showSearch = true);
    });
  }

  void _showLocationError(LocationErrorType errorType) {
    AppSnackBar.showError(context, locationErrorMessage(errorType));
    if (errorType == LocationErrorType.permissionPermanentlyDenied) {
      Geolocator.openAppSettings();
    }
  }

  Future<void> _openAddressSearch() async {
    final selected = await Navigator.of(context).push<AddressModel>(
      MaterialPageRoute(builder: (_) => const AddressSearchScreen()),
    );

    if (!mounted) return;

    if (selected != null) {
      context.go(AppRoutes.home);
      return;
    }

    final state = ref.read(locationControllerProvider);
    if (state.status == LocationStatus.error && state.errorType != null) {
      _showLocationError(state.errorType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: false),
      body: ResponsivePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.spaceXl),
            Text(
              'Hey, nice to meet you!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spaceXs),
            Text(
              'See services around',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppConstants.spaceXl),
            AnimatedSlide(
              offset: _showIllustration ? Offset.zero : const Offset(0, 0.15),
              duration: AppConstants.animMedium,
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _showIllustration ? 1 : 0,
                duration: AppConstants.animMedium,
                curve: Curves.easeOutCubic,
                child: AspectRatio(
                  aspectRatio: 1240 / 564,
                  child: Image.asset(
                    AppAssets.locationIllustration,
                    fit: BoxFit.contain,
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
                label: 'Your current location',
                onPressed: _openAddressSearch,
                icon: Icons.gps_fixed,
                backgroundColor: AppColors.black,
                borderRadius: AppConstants.radiusPill,
              ),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            AnimatedOpacity(
              opacity: _showSearch ? 1 : 0,
              duration: AppConstants.animMedium,
              curve: Curves.easeOutCubic,
              child: SecondaryButton(
                label: 'Some other location',
                onPressed: _openAddressSearch,
                icon: Icons.search,
                borderRadius: AppConstants.radiusPill,
              ),
            ),
            const SizedBox(height: AppConstants.spaceLg),
          ],
        ),
      ),
    );
  }
}
