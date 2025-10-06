import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.0.w,
      decoration: BoxDecoration(
        color: CommonColors.mainRed,
        borderRadius: BorderRadius.circular(12.0.w),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0.w),
          onTap: onPressed,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: CommonColors.white,
                    strokeWidth: 2.w,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.0.w,
                      fontWeight: FontWeight.bold,
                      color: CommonColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}