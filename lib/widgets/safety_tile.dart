import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/text_styles.dart';

class SafetyTile extends StatelessWidget {
  const SafetyTile({
    super.key,
    this.icon,
    this.image,
    required this.title,
    required this.description,
  }) : assert(
         icon != null || image != null,
         'Either icon or image must be provided',
       );

  final IconData? icon;
  final String? image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: icon != null
              ? Icon(icon, size: 32, color: AppColors.textPrimary)
              : Image.asset(image!, fit: BoxFit.contain),
        ),
        const SizedBox(width: AppConstants.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
