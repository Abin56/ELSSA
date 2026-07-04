class AddressModel {
  const AddressModel({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
}
