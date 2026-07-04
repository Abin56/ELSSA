import 'dart:async';

import 'package:flutter/material.dart';

import '../app/constants.dart';
import '../app/colors.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({
    super.key,
    required this.imageAssets,
    this.aspectRatio = 375 / 211,
    this.borderRadius = AppConstants.radiusLg,
    this.autoScrollDuration = const Duration(seconds: 3),
    this.onPageTap,
  });

  final List<String> imageAssets;
  final double aspectRatio;
  final double borderRadius;
  final Duration autoScrollDuration;
  final ValueChanged<int>? onPageTap;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  late final PageController _controller;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  bool get _hasMultipleBanners => widget.imageAssets.length > 1;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    if (_hasMultipleBanners) _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (_) {
      if (!_controller.hasClients) return;
      _controller.nextPage(
        duration: AppConstants.animMedium,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageAssets.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: PageView.builder(
              controller: _controller,
              itemCount: _hasMultipleBanners ? null : 1,
              onPageChanged: (index) => setState(
                () => _currentPage = index % widget.imageAssets.length,
              ),
              itemBuilder: (context, index) {
                final assetIndex = index % widget.imageAssets.length;
                return GestureDetector(
                  onTap: () => widget.onPageTap?.call(assetIndex),
                  child: Image.asset(
                    widget.imageAssets[assetIndex],
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                );
              },
            ),
          ),
        ),
        if (_hasMultipleBanners) ...[
          const SizedBox(height: AppConstants.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imageAssets.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: AppConstants.animFast,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
