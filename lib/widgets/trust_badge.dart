import 'package:flutter/material.dart';

import '../app/constants.dart';
import '../app/text_styles.dart';
import '../app/colors.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key, required this.image, required this.label});

  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, width: 44, height: 44, fit: BoxFit.contain),
        const SizedBox(height: AppConstants.spaceSm),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
