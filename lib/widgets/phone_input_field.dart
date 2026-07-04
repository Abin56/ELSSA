import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/text_styles.dart';
import 'country.dart';
import 'country_picker_sheet.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    super.key,
    this.controller,
    this.hintText = 'Enter Mobile Number',
    this.borderRadius = AppConstants.radiusMd,
    this.onCountryChanged,
  });

  final TextEditingController? controller;
  final String hintText;
  final double borderRadius;
  final void Function(Country country)? onCountryChanged;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  Country _selectedCountry = kCountries.first;

  Future<void> _pickCountry() async {
    final country = await showCountryPicker(context);
    if (country != null) {
      setState(() => _selectedCountry = country);
      widget.onCountryChanged?.call(country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: AppConstants.spaceMd),
          InkWell(
            onTap: _pickCountry,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Row(
              children: [
                Text(
                  _selectedCountry.flag,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: AppConstants.spaceXs),
                Text(
                  '(${_selectedCountry.dialCode})',
                  style: AppTextStyles.bodyMedium,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            height: 24,
            width: 1,
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceSm,
            ),
            color: AppColors.border,
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyles.hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMd),
        ],
      ),
    );
  }
}
