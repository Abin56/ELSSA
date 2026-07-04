import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/config/app_config.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../models/address_model.dart';
import '../providers/location_error_message.dart';
import '../providers/location_provider.dart';
import '../providers/location_state.dart';

class AddressSearchScreen extends ConsumerStatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  ConsumerState<AddressSearchScreen> createState() =>
      _AddressSearchScreenState();
}

class _AddressSearchScreenState extends ConsumerState<AddressSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _selectedPosition = const LatLng(
    AppConstants.defaultMapLatitude,
    AppConstants.defaultMapLongitude,
  );
  bool _hasSelection = false;

  @override
  void initState() {
    super.initState();
    final currentAddress = ref.read(locationControllerProvider).address;
    if (currentAddress != null) {
      _selectedPosition = LatLng(
        currentAddress.latitude,
        currentAddress.longitude,
      );
      _hasSelection = true;
    }
    Future.microtask(_fetchCurrentLocation);
  }

  Future<void> _fetchCurrentLocation() async {
    await ref.read(locationControllerProvider.notifier).fetchCurrentLocation();
    if (!mounted) return;

    final address = ref.read(locationControllerProvider).address;
    if (address == null) return;

    setState(() {
      _selectedPosition = LatLng(address.latitude, address.longitude);
      _hasSelection = true;
    });
    await _moveCamera(_selectedPosition);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      await controller.moveCamera(
        CameraUpdate.newLatLngZoom(
          _selectedPosition,
          _hasSelection ? 16 : AppConstants.defaultMapZoom,
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _moveCamera(LatLng target) async {
    await _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
  }

  Future<void> _selectPlace(Prediction prediction) async {
    final lat = double.tryParse(prediction.lat ?? '');
    final lng = double.tryParse(prediction.lng ?? '');
    if (lat == null || lng == null) {
      AppSnackBar.showError(context, 'Unable to fetch this location.');
      return;
    }

    setState(() {
      _selectedPosition = LatLng(lat, lng);
      _hasSelection = true;
    });
    await _moveCamera(_selectedPosition);
    await ref
        .read(locationControllerProvider.notifier)
        .selectCoordinates(latitude: lat, longitude: lng);
  }

  Future<void> _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _hasSelection = true;
    });
    await ref
        .read(locationControllerProvider.notifier)
        .selectCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        );
  }

  void _confirmSelection(AddressModel address) {
    Navigator.of(context).pop(address);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LocationState>(locationControllerProvider, (previous, next) {
      if (next.status == LocationStatus.error && next.errorType != null) {
        AppSnackBar.showError(context, locationErrorMessage(next.errorType!));
      }
    });

    final state = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Select location'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.horizontalPadding,
            ),
            child: GooglePlacesAutoCompleteTextFormField(
              textEditingController: _searchController,
              config: GoogleApiConfig(
                apiKey: AppConfig.googlePlacesApiKey,
                debounceTime: 400,
                fetchPlaceDetailsWithCoordinates: true,
              ),
              decoration: InputDecoration(
                hintText: 'Search for area, street name...',
                hintStyle: AppTextStyles.hint,
                filled: true,
                fillColor: AppColors.surface,
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSuggestionClicked: (prediction) {
                _searchController.text = prediction.description ?? '';
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _searchController.text.length),
                );
              },
              onPredictionWithCoordinatesReceived: _selectPlace,
            ),
          ),
          const SizedBox(height: AppConstants.spaceMd),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition,
                    zoom: _hasSelection ? 16 : AppConstants.defaultMapZoom,
                  ),
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  markers: _hasSelection
                      ? {
                          Marker(
                            markerId: const MarkerId('selected-location'),
                            position: _selectedPosition,
                          ),
                        }
                      : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                ),
                if (state.isLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x33000000),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.horizontalPadding,
              AppConstants.spaceMd,
              context.horizontalPadding,
              AppConstants.spaceLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.address != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spaceSm,
                    ),
                    child: Text(
                      state.address!.formattedAddress,
                      style: AppTextStyles.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                PrimaryButton(
                  label: 'Confirm location',
                  onPressed: state.address != null
                      ? () => _confirmSelection(state.address!)
                      : null,
                  isLoading: state.isLoading,
                  borderRadius: AppConstants.radiusPill,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
