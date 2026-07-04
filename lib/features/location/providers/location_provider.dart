import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/location_repository.dart';
import '../data/location_service.dart';
import 'location_state.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(
    locationService: ref.watch(locationServiceProvider),
  );
});

final locationControllerProvider =
    StateNotifierProvider<LocationController, LocationState>((ref) {
      return LocationController(
        repository: ref.watch(locationRepositoryProvider),
      );
    });

class LocationController extends StateNotifier<LocationState> {
  LocationController({required this._repository})
    : super(const LocationState());

  final LocationRepository _repository;

  Future<void> fetchCurrentLocation() async {
    state = state.copyWith(status: LocationStatus.loading);

    try {
      final address = await _repository.getCurrentAddress();
      state = state.copyWith(status: LocationStatus.loaded, address: address);
    } on LocationPermissionDeniedException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.permissionDenied,
      );
    } on LocationPermissionPermanentlyDeniedException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.permissionPermanentlyDenied,
      );
    } on LocationServiceDisabledException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.serviceDisabled,
      );
    } on GeocodingException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.geocodingFailed,
      );
    } on LocationFetchException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.fetchFailed,
      );
    } catch (_) {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.network,
      );
    }
  }

  Future<void> selectCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(status: LocationStatus.loading);

    try {
      final address = await _repository.getAddressFromCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      state = state.copyWith(status: LocationStatus.loaded, address: address);
    } on GeocodingException {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.geocodingFailed,
      );
    } catch (_) {
      state = state.copyWith(
        status: LocationStatus.error,
        errorType: LocationErrorType.network,
      );
    }
  }
}
