import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/text_styles.dart';
import 'country.dart';

Future<Country?> showCountryPicker(BuildContext context) {
  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppConstants.radiusLg),
      ),
    ),
    builder: (context) => const CountryPickerSheet(),
  );
}

class CountryPickerSheet extends StatelessWidget {
  const CountryPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.7.sh),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConstants.spaceSm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              child: Text('Select Country', style: AppTextStyles.titleLarge),
            ),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spaceMd,
                ),
                itemCount: kCountries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final country = kCountries[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(country.name, style: AppTextStyles.bodyLarge),
                    trailing: Text(
                      country.dialCode,
                      style: AppTextStyles.bodyMedium,
                    ),
                    onTap: () => Navigator.of(context).pop(country),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.spaceSm),
          ],
        ),
      ),
    );
  }
}
