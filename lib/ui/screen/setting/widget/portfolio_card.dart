import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/setting/widget/portfolio_input.dart';

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
        color: CommonColors.white,
        borderRadius: BorderRadius.circular(12.0.w),
        boxShadow: [
          BoxShadow(
            color: CommonColors.mainBlack.withValues(alpha: 0.08),
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
                  fontSize: 20.w,
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

          SizedBox(height: 10.w),

          // 평균 매수가
          PortfolioInput(
            label: 'Average Price',
            textController: averagePriceController,
            hint: '0.00',
            validator: averagePriceValidator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffix: 'USD',
          ),
          SizedBox(height: 10.w),
          // 메모
          PortfolioInput(
            label: 'Memo',
            textController: memoController,
            hint: 'Investment notes...',
            maxLines: 3,
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
