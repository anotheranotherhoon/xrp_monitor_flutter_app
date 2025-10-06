import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class AuthHeader extends StatelessWidget {
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'XRP Monitor',
          style: TextStyle(
            fontSize: 32.w,
            fontWeight: FontWeight.bold,
            color: CommonColors.subBlue,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.w),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16.w,
            color: CommonColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}