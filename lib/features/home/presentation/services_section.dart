import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../widgets/home_service_card.dart';
import '../../../widgets/section_title.dart';

class PopularServiceItem {
  const PopularServiceItem({required this.title, this.image});

  final String title;
  final String? image;
}

const popularServices = [
  PopularServiceItem(
    title: 'Kitchen Cleaning',
    image: AppAssets.kitchenCleaning,
  ),
  PopularServiceItem(title: 'Sofa Cleaning'),
  PopularServiceItem(
    title: 'Full House Cleaning',
    image: AppAssets.fullHomeCleaning,
  ),
  PopularServiceItem(title: 'Bathroom Cleaning'),
];

const cleaningServices = [
  PopularServiceItem(
    title: 'Kitchen Cleaning',
    image: AppAssets.kitchenCleaningService,
  ),
  PopularServiceItem(
    title: 'Sofa Cleaning',
    image: AppAssets.sofaCleaningService,
  ),
  PopularServiceItem(
    title: 'Full House Cleaning',
    image: AppAssets.fullHomeCleaningService,
  ),
  PopularServiceItem(title: 'Bathroom Cleaning'),
];

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Popular Services'),
        SizedBox(height: AppConstants.spaceSm),
        _PopularServicesList(services: popularServices),
        SizedBox(height: AppConstants.spaceMd),
        SectionTitle(title: 'Cleaning Services'),
        SizedBox(height: AppConstants.spaceSm),
        _PopularServicesList(services: cleaningServices),
      ],
    );
  }
}

class _PopularServicesList extends StatelessWidget {
  const _PopularServicesList({required this.services});

  final List<PopularServiceItem> services;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppConstants.spaceMd),
        itemBuilder: (context, index) {
          final service = services[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: AppConstants.animMedium,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: HomeServiceCard(
              title: service.title,
              imageAsset: service.image,
            ),
          );
        },
      ),
    );
  }
}
