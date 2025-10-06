import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/setting/models/portfolio_model.dart';
import 'package:xrp_monitor/utils/formatter.dart';


class ChartCurrentPriceCard extends StatelessWidget {
  const ChartCurrentPriceCard({
    required this.currentPrice,
    this.portfolio,
    super.key});

  final double currentPrice;
  final Portfolio? portfolio;

  @override
  Widget build(BuildContext context) {
    // 평가손익 및 수익률 계산
    double profitLoss = 0;
    double profitRate = 0;
    Color profitColor = CommonColors.grey;
    
    if (portfolio != null && currentPrice > 0) {
      final avgPrice = double.tryParse(portfolio!.averagePrice) ?? 0;
      final quantity = double.tryParse(portfolio!.quantity) ?? 0;
      
      if (avgPrice > 0 && quantity > 0) {
        profitLoss = (currentPrice - avgPrice) * quantity;
        profitRate = ((currentPrice - avgPrice) / avgPrice) * 100;
        profitColor = profitLoss >= 0 ? CommonColors.mainRed : CommonColors.chartBlue;
      }
    }

    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0.w),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.xrpCurrentPrice,
            style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.0.w),
          Text(
            currentPrice > 0
                ? '${Formatter.formatWithCommaNoLimit(currentPrice)} KRW'
                : AppStrings.connecting,
            style: TextStyle(
              fontSize: 24.w,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          if (portfolio != null) ...[
            SizedBox(height: 12.0.w),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 12.0.w),
            
            // 평균매수가
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.xrpAveragePrice,
                  style: TextStyle(
                    fontSize: 14.w,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${Formatter.formatWithCommaNoLimit(double.tryParse(portfolio!.averagePrice) ?? 0)} KRW',
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.w),
            
            // 보유량
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.xrpHoldings,
                  style: TextStyle(
                    fontSize: 14.w,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${Formatter.formatWithCommaNoLimit(double.tryParse(portfolio!.quantity) ?? 0)} XRP',
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.w),
            
            // 평가손익
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.valuationGainLoss,
                  style: TextStyle(
                    fontSize: 14.w,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${profitLoss >= 0 ? '+' : ''}${Formatter.formatWithCommaAndDecimal(profitLoss, 0)} KRW',
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.bold,
                    color: profitColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.w),
            
            // 수익률
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.roi,
                  style: TextStyle(
                    fontSize: 14.w,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${profitRate >= 0 ? '+' : ''}${Formatter.formatWithCommaAndDecimal(profitRate, 2)}%',
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.bold,
                    color: profitColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
