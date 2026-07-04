import '../models/address_model.dart';

enum LocationStatus { initial, loading, loaded, error }

enum LocationErrorType {
  permissionDenied,
  permissionPermanentlyDenied,
  serviceDisabled,
  network,
  fetchFailed,
  geocodingFailed,
}

class LocationState {
  const LocationState({
    this.status = LocationStatus.initial,
    this.address,
    this.errorType,
  });

  final LocationStatus status;
  final AddressModel? address;
  final LocationErrorType? errorType;

  bool get isLoading => status == LocationStatus.loading;

  LocationState copyWith({
    LocationStatus? status,
    AddressModel? address,
    LocationErrorType? errorType,
  }) {
    return LocationState(
      status: status ?? this.status,
      address: address ?? this.address,
      errorType: errorType,
    );
  }
}
