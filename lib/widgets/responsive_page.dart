import 'package:flutter/material.dart';

import '../core/extensions/context_extensions.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.child,
    this.scrollable = true,
    this.applyPadding = true,
  });

  final Widget child;
  final bool scrollable;
  final bool applyPadding;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: applyPadding
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.horizontalPadding,
                ),
                child: child,
              )
            : child,
      ),
    );

    if (scrollable) {
      content = CustomScrollView(
        slivers: [SliverFillRemaining(hasScrollBody: false, child: content)],
      );
    }

    return SafeArea(child: content);
  }
}
