import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/address_model.dart';

class LocationPermissionDeniedException implements Exception {}

class LocationPermissionPermanentlyDeniedException implements Exception {}

class LocationServiceDisabledException implements Exception {}

class LocationFetchException implements Exception {}

class GeocodingException implements Exception {}

class LocationService {
  final Geocoding _geocoding = Geocoding();

  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionPermanentlyDeniedException();
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      throw LocationFetchException();
    }
  }

  Future<AddressModel> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isEmpty) {
        throw GeocodingException();
      }

      final placemark = placemarks.first;
      final formattedAddress = [
        placemark.street,
        placemark.subLocality,
        placemark.locality,
      ].where((part) => part != null && part.isNotEmpty).join(', ');

      return AddressModel(
        latitude: latitude,
        longitude: longitude,
        formattedAddress: formattedAddress.isNotEmpty
            ? formattedAddress
            : 'Unknown location',
        city: placemark.locality,
        state: placemark.administrativeArea,
        country: placemark.country,
        postalCode: placemark.postalCode,
      );
    } catch (_) {
      throw GeocodingException();
    }
  }
}
