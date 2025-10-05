import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/screen/profile/widget/portfolio_input.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    required this.quantityController,
    required this.averagePriceController,
    required this.memoController,
    required this.quantityValidator,
    required this.averagePriceValidator,
    super.key});

  final TextEditingController quantityController;
  final TextEditingController averagePriceController;
  final TextEditingController memoController;
  final String? Function(String?) quantityValidator;
  final String? Function(String?) averagePriceValidator;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'XRP Portfolio',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // XRP 보유량
          PortfolioInput(
            label: 'XRP Holdings',
            textController: quantityController,
            hint: '0.00',
            validator: quantityValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'XRP',
          ),
          SizedBox(height: 20.h),

          // 평균 매수가
          PortfolioInput(
            label: 'Average Price',
            textController: averagePriceController,
            hint: '0.00',
            validator: averagePriceValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'USD',
          ),
          SizedBox(height: 20.h),

          // 메모
          PortfolioInput(
            label: 'Notes',
            textController: memoController,
            hint: 'Investment notes...',
            maxLines: 3,
          ),
          SizedBox(height: 32.h),

          // 저장 버튼
          Container(
            width: double.infinity,
            height: 48.h,
            margin: EdgeInsets.symmetric(vertical: 8.h),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                print('Save Changes 버튼 클릭됨!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B9687),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                shadowColor: Colors.black.withValues(alpha: 0.1),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
