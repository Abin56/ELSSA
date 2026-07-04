class AppConstants {
  AppConstants._();

  static const double defaultMapLatitude = 25.2048;
  static const double defaultMapLongitude = 55.2708;
  static const double defaultMapZoom = 12;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double spaceXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  static const double maxContentWidth = 480;
  static const double bottomNavHeight = 64;

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
}

class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';
  static const String _homeImages = 'assets/images/home';
  static const String _navIcons = 'assets/icons/nav';
  static const String _categoryIcons = 'assets/icons/categories';
  static const String _popularServiceImages = 'assets/images/popular_services';
  static const String _cleaningServiceImages =
      'assets/images/cleaning_services';
  static const String _whyChooseUsImages = 'assets/images/why_choose_us';
  static const String _safetyImages = 'assets/images/safety';
  static const String _trustBadgeImages = 'assets/images/trust_badges';

  static const String logo = '$_images/elssa_logo.png';
  static const String loginIllustration = '$_images/login_illustration.jpg';
  static const String otpIllustration = '$_images/otp_illustration.jpg';
  static const String locationIllustration =
      '$_images/location_illustration.png';
  static const String facebookLogo = '$_images/facebook_logo.png';

  static const String homeBanner = '$_homeImages/home_banner.png';

  static const String navHome = '$_navIcons/home.png';
  static const String navRewards = '$_navIcons/rewards.png';
  static const String navBookings = '$_navIcons/bookings.png';
  static const String navProfile = '$_navIcons/profile.png';

  static const String renovation = '$_categoryIcons/renovation.png';
  static const String handyman = '$_categoryIcons/handyman.png';
  static const String homeShifting = '$_categoryIcons/home_shifting.png';
  static const String gardening = '$_categoryIcons/gardening.png';
  static const String declutter = '$_categoryIcons/declutter.png';
  static const String painting = '$_categoryIcons/painting.png';

  static const String kitchenCleaning =
      '$_popularServiceImages/kitchen_cleaning.png';
  static const String fullHomeCleaning =
      '$_popularServiceImages/full_home_cleaning.jpg';

  static const String kitchenCleaningService =
      '$_cleaningServiceImages/kitchen_cleaning.jpg';
  static const String sofaCleaningService =
      '$_cleaningServiceImages/sofa_cleaning.jpg';
  static const String fullHomeCleaningService =
      '$_cleaningServiceImages/full_home_cleaning.jpg';

  static const String qualityAssurance =
      '$_whyChooseUsImages/quality_assurance.png';
  static const String fixedPrices = '$_whyChooseUsImages/fixed_prices.png';
  static const String hassleFree = '$_whyChooseUsImages/hassle_free.png';

  static const String safetyIcon = '$_safetyImages/safety_icon.png';

  static const String isoBadge = '$_trustBadgeImages/iso_badge.jpg';
  static const String verifiedBadge = '$_trustBadgeImages/verified_badge.png';
  static const String customerChoiceBadge =
      '$_trustBadgeImages/customer_choice.png';
  static const String bestServiceBadge = '$_trustBadgeImages/best_service.png';
  static const String topRatedBadge = '$_trustBadgeImages/top_rated.png';
}
