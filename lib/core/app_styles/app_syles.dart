import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors_manager.dart';

class AppStyle {
  static TextStyle tabHeader = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.white,
  );
  static TextStyle movieDetails =TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.white.withOpacity(.67),
  );
  static TextStyle categoryLabel = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.white,
  );
  static TextStyle movieName = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static TextStyle noMoviesFound = TextStyle(
      color: ColorsManager.white, fontSize: 18.sp, fontWeight: FontWeight.w400
  );

}