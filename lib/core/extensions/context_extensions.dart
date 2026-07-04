import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _tabletWidth = 600.0;

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  bool get isTablet => ScreenUtil().screenWidth >= _tabletWidth;

  double get horizontalPadding => isTablet ? 32.w : 20.w;
  double get maxContentWidth => isTablet ? 500.w : double.infinity;
}
