import 'package:flutter/material.dart';

import '../../../app/colors.dart';
import '../../../app/constants.dart';
import '../../../widgets/category_item.dart';

class CategoryData {
  const CategoryData({required this.label, this.image, this.icon})
    : assert(image != null || icon != null);

  final String label;
  final String? image;
  final IconData? icon;
}

const categories = [
  CategoryData(image: AppAssets.renovation, label: 'Renovation'),
  CategoryData(image: AppAssets.handyman, label: 'Handyman'),
  CategoryData(image: AppAssets.homeShifting, label: 'Home shifting'),
  CategoryData(image: AppAssets.gardening, label: 'Gardening'),
  CategoryData(image: AppAssets.declutter, label: 'Declutter'),
  CategoryData(image: AppAssets.painting, label: 'Painting'),
];

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const int _crossAxisCount = 3;

  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final rowCount = (categories.length / _crossAxisCount).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final isLastColumn = (index + 1) % _crossAxisCount == 0;
        final isLastRow = index ~/ _crossAxisCount == rowCount - 1;
        final category = categories[index];

        return Container(
          decoration: BoxDecoration(
            border: Border(
              right: isLastColumn
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.border),
              bottom: isLastRow
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.border),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceXs),
          child: CategoryItem(
            image: category.image,
            icon: category.icon,
            label: category.label,
            selected: selectedIndex == index,
            onTap: () => onSelected(index),
          ),
        );
      },
    );
  }
}
