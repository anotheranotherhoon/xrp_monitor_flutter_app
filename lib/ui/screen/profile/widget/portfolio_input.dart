import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PortfolioInput extends StatelessWidget {
  const PortfolioInput({
    required this.label,
    required this.textController,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.suffix,
    this.maxLines = 1,
    super.key});


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
        SizedBox(height: 8.h),
        TextFormField(
          controller: textController,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: keyboardType == const TextInputType.numberWithOptions(decimal: true)
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
              : null,
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF2D3748),
            fontWeight: FontWeight.w500,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFF0B9687),
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}

