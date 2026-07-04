import 'package:flutter/material.dart';

import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../app/text_styles.dart';
import '../../../widgets/why_choose_card.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.textPrimary),
            const SizedBox(width: AppConstants.spaceSm),
            Text('Why Choose Us', style: AppTextStyles.titleLarge),
          ],
        ),
        const SizedBox(height: AppConstants.spaceMd),
        const WhyChooseCard(
          image: AppAssets.hassleFree,
          title: 'Quality Assurance',
          description: 'Your satisfaction is guaranteed',
        ),
        const SizedBox(height: AppConstants.spaceSm),
        const WhyChooseCard(
          image: AppAssets.fixedPrices,
          title: 'Fixed Prices',
          description:
              'No hidden costs, all the prices are known and fixed before booking',
        ),
        const SizedBox(height: AppConstants.spaceSm),
        const WhyChooseCard(
          image: AppAssets.qualityAssurance,
          title: 'Hassle free',
          description: 'convenient, time saving and secure',
        ),
      ],
    );
  }
}
