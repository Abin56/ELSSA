import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../app/text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.locationLabel,
    required this.addressLine,
    this.onLocationTap,
    this.onSearchTap,
  });

  final String locationLabel;
  final String addressLine;
  final VoidCallback? onLocationTap;
  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: onLocationTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(locationLabel, style: AppTextStyles.titleMedium),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  addressLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: onSearchTap,
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.search, color: AppColors.textPrimary, size: 24),
          ),
        ),
      ],
    );
  }
}
