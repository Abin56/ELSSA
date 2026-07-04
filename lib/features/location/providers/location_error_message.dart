import 'location_state.dart';

String locationErrorMessage(LocationErrorType errorType) {
  switch (errorType) {
    case LocationErrorType.permissionDenied:
      return 'Location permission denied. Please allow access to continue.';
    case LocationErrorType.permissionPermanentlyDenied:
      return 'Location permission is permanently denied. Enable it from app settings.';
    case LocationErrorType.serviceDisabled:
      return 'Location services are turned off. Please enable GPS.';
    case LocationErrorType.network:
      return 'Network unavailable. Please check your internet connection.';
    case LocationErrorType.fetchFailed:
      return 'Unable to fetch your current location. Please try again.';
    case LocationErrorType.geocodingFailed:
      return 'Unable to resolve address for this location.';
  }
}
