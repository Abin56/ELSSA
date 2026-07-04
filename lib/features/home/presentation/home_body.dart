import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../features/location/presentation/address_search_screen.dart';
import '../../../features/location/providers/location_provider.dart';
import '../../../widgets/home_banner_carousel.dart';
import '../../../widgets/home_header.dart';
import 'category_section.dart';
import 'safety_section.dart';
import 'services_section.dart';
import 'trust_badges_row.dart';
import 'why_choose_us_section.dart';

const _bannerAssets = [
  AppAssets.homeBanner,
  AppAssets.homeBanner,
  AppAssets.homeBanner,
];

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  bool _showBanner = false;
  bool _showCategories = false;
  bool _showLists = false;

  int? _selectedCategoryIndex;

  Future<void> _openLocationPicker() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddressSearchScreen()));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _showBanner = true);
    });
    Future.delayed(const Duration(milliseconds: 220), () {
      if (mounted) setState(() => _showCategories = true);
    });
    Future.delayed(const Duration(milliseconds: 340), () {
      if (mounted) setState(() => _showLists = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.horizontalPadding;
    final address = ref.watch(
      locationControllerProvider.select((state) => state.address),
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ).copyWith(top: AppConstants.spaceSm),
          sliver: SliverToBoxAdapter(
            child: HomeHeader(
              locationLabel: address?.city ?? 'Home',
              addressLine:
                  address?.formattedAddress ??
                  'Set your location to see services around you',
              onLocationTap: _openLocationPicker,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ).copyWith(top: AppConstants.spaceMd),
          sliver: SliverToBoxAdapter(
            child: _FadeSlideIn(
              visible: _showBanner,
              child: const HomeBannerCarousel(imageAssets: _bannerAssets),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SectionGap()),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ).copyWith(top: AppConstants.spaceMd),
          sliver: SliverToBoxAdapter(
            child: _FadeSlideIn(
              visible: _showCategories,
              child: CategorySection(
                selectedIndex: _selectedCategoryIndex,
                onSelected: (index) => setState(
                  () => _selectedCategoryIndex = _selectedCategoryIndex == index
                      ? null
                      : index,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SectionGap()),
        SliverToBoxAdapter(
          child: AnimatedOpacity(
            opacity: _showLists ? 1 : 0,
            duration: AppConstants.animMedium,
            curve: Curves.easeOutCubic,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppConstants.spaceMd),
                  ServicesSection(),
                  SizedBox(height: AppConstants.spaceLg),
                  TrustBadgesRow(),
                  SizedBox(height: AppConstants.spaceLg),
                  WhyChooseUsSection(),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SafetySection()),
      ],
    );
  }
}

class _FadeSlideIn extends StatelessWidget {
  const _FadeSlideIn({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 0.1),
      duration: AppConstants.animMedium,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: AppConstants.animMedium,
        curve: Curves.easeOutCubic,
        child: child,
      ),
    );
  }
}

class _SectionGap extends StatelessWidget {
  const _SectionGap();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: SizedBox(height: AppConstants.spaceMd, width: double.infinity),
    );
  }
}
