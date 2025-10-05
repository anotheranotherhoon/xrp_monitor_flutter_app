import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class PortfolioInput extends StatelessWidget {
  const PortfolioInput({
    required this.label,
    required this.textController,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.suffix,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final TextEditingController textController;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 6.w), // 여백 증가

        // Container로 감싸고 clipBehavior 적용
        Container(
          clipBehavior: Clip.antiAlias, // 모서리 둥글게 잘림 처리
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.w), // 직접 픽셀값 사용
          ),
          child: TextFormField(
            controller: textController,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: maxLines > 1 ? 3 : 1, // 다중라인일 때 최소 3줄 확보
            textAlignVertical: maxLines > 1
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            inputFormatters: keyboardType ==
                const TextInputType.numberWithOptions(decimal: true)
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : null,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF2D3748),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFA0AEC0),
                fontSize: 16.sp,
              ),
              suffixText: suffix,
              suffixStyle: TextStyle(
                color: const Color(0xFF718096),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              isDense: false, // 밀도를 낮춰서 여백 확보
              contentPadding: maxLines > 1
                  ? EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h) // 다중라인: 훨씬 큰 여백
                  : EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h), // 단일라인: 충분한 여백
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.w), // 직접 픽셀값
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.w),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.w),
                borderSide: BorderSide(color: CommonColors.mainNavy, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.w),
                borderSide: BorderSide(color: CommonColors.mainRed, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0.w),
                borderSide: BorderSide(color: CommonColors.mainRed, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
