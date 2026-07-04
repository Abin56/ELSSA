import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../widgets/trust_badge.dart';

class TrustBadgesRow extends StatelessWidget {
  const TrustBadgesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 96,
      child: Row(
        children: [
          Expanded(
            child: TrustBadge(
              image: AppAssets.bestServiceBadge,
              label: 'On Demand / Scheduled',
            ),
          ),
          Expanded(
            child: TrustBadge(
              image: AppAssets.topRatedBadge,
              label: 'Verified Partners',
            ),
          ),
          Expanded(
            child: TrustBadge(
              image: AppAssets.customerChoiceBadge,
              label: 'Satisfaction Guarantee',
            ),
          ),
          Expanded(
            child: TrustBadge(
              image: AppAssets.verifiedBadge,
              label: 'Upfront Pricing',
            ),
          ),
          Expanded(
            child: TrustBadge(
              image: AppAssets.isoBadge,
              label: 'Highly Trained Professionals',
            ),
          ),
        ],
      ),
    );
  }
}
