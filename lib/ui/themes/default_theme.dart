import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

final ThemeData defaultTheme = ThemeData(
  fontFamily: 'PretendardJP',

  appBarTheme: AppBarTheme(
    toolbarHeight: 44.w,
    elevation: 0,
    backgroundColor: CommonColors.white,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16.sp, color: CommonColors.mainBlack),
    bodyMedium: TextStyle(fontSize: 14.sp, color: CommonColors.mainBlack),
    labelSmall: TextStyle(fontSize: 12.sp, color: CommonColors.mainBlack),
  ),

  scaffoldBackgroundColor: Colors.white,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0B9687),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white,
      disabledBackgroundColor: Color(0xff959595),
      padding: EdgeInsets.symmetric(vertical: 12.w),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1.w)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1.w)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff0B9687), width: 1.w)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffF7585F), width: 1.w)),
  ),

  textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xff4EBDAD)),
);
