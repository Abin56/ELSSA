class Country {
  const Country({
    required this.name,
    required this.flag,
    required this.dialCode,
  });

  final String name;
  final String flag;
  final String dialCode;
}

const List<Country> kCountries = [
  Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
  Country(name: 'India', flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
  Country(name: 'Germany', flag: '🇩🇪', dialCode: '+49'),
  Country(name: 'France', flag: '🇫🇷', dialCode: '+33'),
  Country(name: 'United Arab Emirates', flag: '🇦🇪', dialCode: '+971'),
  Country(name: 'Saudi Arabia', flag: '🇸🇦', dialCode: '+966'),
  Country(name: 'Singapore', flag: '🇸🇬', dialCode: '+65'),
  Country(name: 'Pakistan', flag: '🇵🇰', dialCode: '+92'),
  Country(name: 'Bangladesh', flag: '🇧🇩', dialCode: '+880'),
  Country(name: 'Nigeria', flag: '🇳🇬', dialCode: '+234'),
  Country(name: 'South Africa', flag: '🇿🇦', dialCode: '+27'),
  Country(name: 'Brazil', flag: '🇧🇷', dialCode: '+55'),
  Country(name: 'Japan', flag: '🇯🇵', dialCode: '+81'),
  Country(name: 'China', flag: '🇨🇳', dialCode: '+86'),
  Country(name: 'Philippines', flag: '🇵🇭', dialCode: '+63'),
];
