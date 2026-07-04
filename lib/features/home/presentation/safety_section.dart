import 'package:flutter/material.dart';

import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../widgets/safety_tile.dart';

class SafetySection extends StatelessWidget {
  const SafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.horizontalPadding;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.textPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppConstants.spaceLg,
          ),
          child: Text(
            'Best-in Class Safety Measures',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
          ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppConstants.spaceLg,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                decoration: BoxDecoration(
                  // color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SafetyTile(
                      image: AppAssets.maskIcon,
                      title: 'Usage of masks, gloves & Sanitisers',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing in. Dictumst nullam mauris malesuada in. Eget in condimentum portior nec tristique penatibus ipsum.',
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    const SafetyTile(
                      image: AppAssets.lowContactIcon,
                      title: 'Low-contact Service Experience',
                      description:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing in. Dictumst nullam mauris malesuada in. Eget in condimentum portior nec tristique penatibus ipsum.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spaceXl),
              Center(
                child: Text(
                  'HASSLE FREE\nQUALITY SERVICE',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Center(child: Text('V 1.0', style: AppTextStyles.caption)),
            ],
          ),
        ),
      ],
    );
  }
}
