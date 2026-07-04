import 'package:flutter/material.dart';

import '../app/colors.dart';
import '../app/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onBackTap,
  });

  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(title!, style: AppTextStyles.titleLarge)
          : null,
      centerTitle: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: AppColors.textPrimary,
              ),
              onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
