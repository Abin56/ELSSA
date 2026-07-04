import '../models/address_model.dart';
import 'location_service.dart';

class LocationRepository {
  LocationRepository({required this._locationService});

  final LocationService _locationService;

  Future<AddressModel> getCurrentAddress() async {
    final position = await _locationService.getCurrentPosition();
    return _locationService.reverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<AddressModel> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return _locationService.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
