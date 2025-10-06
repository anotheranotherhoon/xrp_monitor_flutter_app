import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: CommonColors.mainBlue,  // ✅ 여기서 선택
  secondaryHeaderColor: CommonColors.subBlue,
  scaffoldBackgroundColor: CommonColors.white,
  fontFamily: 'PretendardJP',
  splashColor: Color(0xFF00A5DF).withOpacity(0.2),
  highlightColor: Color(0xFF00A5DF).withOpacity(0.1),
  appBarTheme: AppBarTheme(
    toolbarHeight: 44.w,
    elevation: 0,
    backgroundColor: CommonColors.white,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16.w, color: CommonColors.mainBlack),
    bodyMedium: TextStyle(fontSize: 14.w, color: CommonColors.mainBlack),
    labelSmall: TextStyle(fontSize: 12.w, color: CommonColors.mainBlack),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF00A5DF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
      textStyle: TextStyle(color: CommonColors.white, fontWeight: FontWeight.w400),
      foregroundColor: CommonColors.white,
      disabledForegroundColor: CommonColors.white,
      disabledBackgroundColor: Color(0xff959595),
      padding: EdgeInsets.symmetric(vertical: 12.w),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1.w)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1.w)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00A5DF), width: 1.w)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffF7585F), width: 1.w)),
  ),

  textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xFF00A5DF)),
);
