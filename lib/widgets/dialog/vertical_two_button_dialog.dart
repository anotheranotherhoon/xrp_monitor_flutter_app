import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class VerticalTwoButtonDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback onCancel;

  const VerticalTwoButtonDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    required this.onConfirm,
    this.cancelText,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: CommonColors.mainBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.w),

              Flexible(child: content),

              SizedBox(height: 16.w),

              ElevatedButton(
                onPressed: onConfirm,
                child: Text(
                  confirmText ?? '완료',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.w),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.w),
                ),
                onPressed: onCancel,
                child: Text(
                  cancelText ?? '취소',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: CommonColors.mainBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
