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
                    fontWeight: FontWeight.w700,
                    fontSize: 18.w,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.w),

              Flexible(child: content),

              SizedBox(height: 16.w),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.w),
                        backgroundColor: CommonColors.mainNavy,
                        foregroundColor: CommonColors.white,
                      ),
                      child: Text(
                        confirmText ?? '완료',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.w,
                          color: CommonColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w), // 버튼 사이 간격
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.w),
                        backgroundColor: CommonColors.grey400,
                        foregroundColor: CommonColors.white,
                      ),
                      child: Text(
                        cancelText ?? '취소',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.w,
                          color: CommonColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
