import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChartCurrentPriceCard extends StatelessWidget {
  const ChartCurrentPriceCard({
    required this.currentPrice,
    super.key});

  final double currentPrice;

  @override
  Widget build(BuildContext context) {
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
            'XRP Current Price',
            style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.0.w),
          Text(
            currentPrice > 0
                ? '${currentPrice.toStringAsFixed(2)} KRW'
                : '연결 중...',
            style: TextStyle(
              fontSize: 24.w,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
