import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../app/constants.dart';
import '../app/text_styles.dart';

enum BottomNavTab { home, rewards, orders, bookings, profile }

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const List<BottomNavTab> _tabs = [
    BottomNavTab.home,
    BottomNavTab.rewards,
    BottomNavTab.orders,
    BottomNavTab.bookings,
    BottomNavTab.profile,
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppConstants.bottomNavHeight,
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Expanded(
                  child: _NavItem(
                    tab: _tabs[i],
                    isActive: i == currentIndex,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final BottomNavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  String get _label {
    switch (tab) {
      case BottomNavTab.home:
        return 'Home';
      case BottomNavTab.rewards:
        return 'Rewards';
      case BottomNavTab.orders:
        return 'My Orders';
      case BottomNavTab.bookings:
        return 'Bookings';
      case BottomNavTab.profile:
        return 'Profile';
    }
  }

  Widget _icon(Color color) {
    if (tab == BottomNavTab.orders) {
      return Icon(Icons.receipt_long_outlined, size: 22, color: color);
    }

    final String asset;
    switch (tab) {
      case BottomNavTab.home:
        asset = AppAssets.navHome;
        break;
      case BottomNavTab.rewards:
        asset = AppAssets.navRewards;
        break;
      case BottomNavTab.bookings:
        asset = AppAssets.navBookings;
        break;
      case BottomNavTab.profile:
        asset = AppAssets.navProfile;
        break;
      case BottomNavTab.orders:
        asset = '';
        break;
    }
    return Image.asset(asset, width: 22, height: 22, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textHint;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isActive ? 1.1 : 1.0,
            duration: AppConstants.animFast,
            curve: Curves.easeOut,
            child: _icon(color),
          ),
          const SizedBox(height: AppConstants.spaceXs),
          AnimatedDefaultTextStyle(
            duration: AppConstants.animFast,
            curve: Curves.easeOut,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(_label),
          ),
        ],
      ),
    );
  }
}
