import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base =>
      GoogleFonts.poppins(color: AppColors.textPrimary);

  static TextStyle get h1 =>
      _base.copyWith(fontSize: 28.sp, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get h2 =>
      _base.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get h3 =>
      _base.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle get titleLarge =>
      _base.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w600);
  static TextStyle get titleMedium =>
      _base.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      _base.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400);
  static TextStyle get bodyMedium =>
      _base.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400);
  static TextStyle get bodySmall =>
      _base.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400);

  static TextStyle get buttonLarge => _base.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  static TextStyle get buttonMedium => _base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get caption => _base.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );
  static TextStyle get hint => _base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static TextStyle get link => _base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
