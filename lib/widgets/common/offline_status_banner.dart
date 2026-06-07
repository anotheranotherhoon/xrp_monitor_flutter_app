import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfflineStatusBanner extends StatelessWidget {
  const OfflineStatusBanner({
    required this.hasPendingSync,
    this.lastUpdatedAt,
    super.key,
  });

  final bool hasPendingSync;
  final DateTime? lastUpdatedAt;

  @override
  Widget build(BuildContext context) {
    final updatedAt = lastUpdatedAt;
    final timeText =
        updatedAt == null
            ? ''
            : ' · 마지막 저장 ${_twoDigits(updatedAt.hour)}:${_twoDigits(updatedAt.minute)}';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFE08A)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              hasPendingSync
                  ? '오프라인 · 변경사항은 연결되면 자동 동기화됩니다$timeText'
                  : '오프라인 · 저장된 데이터를 표시하고 있습니다$timeText',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B5200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class NetworkOfflineBar extends StatelessWidget {
  const NetworkOfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF3CD),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 17.w,
              color: const Color(0xFF6B5200),
            ),
            SizedBox(width: 7.w),
            Flexible(
              child: Text(
                '네트워크 연결 없음 · 저장된 데이터를 표시합니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B5200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
