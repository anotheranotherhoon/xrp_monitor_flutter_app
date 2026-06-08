import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/services/popup/models/popup_model.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';

class HomePopupDialog extends StatefulWidget {
  const HomePopupDialog({
    required this.popups,
    required this.onHideToday,
    required this.onClose,
    this.onLaunchExternal,
    super.key,
  });

  final List<PopupModel> popups;
  final Future<void> Function() onHideToday;
  final VoidCallback onClose;
  final Future<void> Function(String url)? onLaunchExternal;

  @override
  State<HomePopupDialog> createState() => _HomePopupDialogState();
}

class _HomePopupDialogState extends State<HomePopupDialog> {
  int _currentIndex = 0;
  late List<PopupModel> _visiblePopups;
  Timer? _expirationTimer;

  @override
  void initState() {
    super.initState();
    _visiblePopups = _notExpired(widget.popups);
    _scheduleExpiration();
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    super.dispose();
  }

  List<PopupModel> _notExpired(List<PopupModel> popups) {
    final DateTime now = DateTime.now();
    return popups.where((PopupModel popup) {
      final DateTime? endAt = popup.localEndAt;
      return endAt == null || now.isBefore(endAt);
    }).toList();
  }

  void _scheduleExpiration() {
    _expirationTimer?.cancel();
    final DateTime now = DateTime.now();
    final List<DateTime> endTimes =
        _visiblePopups
            .map((PopupModel popup) => popup.localEndAt)
            .whereType<DateTime>()
            .where((DateTime endAt) => endAt.isAfter(now))
            .toList()
          ..sort();
    if (endTimes.isEmpty) return;

    final DateTime expirationTime = endTimes.first;
    _expirationTimer = Timer(
      expirationTime.difference(now),
      () => _removeExpired(expirationTime),
    );
  }

  void _removeExpired(DateTime expirationTime) {
    if (!mounted) return;
    final List<PopupModel> remaining =
        _visiblePopups.where((PopupModel popup) {
          final DateTime? endAt = popup.localEndAt;
          return endAt == null || endAt.isAfter(expirationTime);
        }).toList();
    if (remaining.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _visiblePopups = remaining;
      if (_currentIndex >= remaining.length) {
        _currentIndex = remaining.length - 1;
      }
    });
    _scheduleExpiration();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double dialogWidth = screenSize.width - 40.w;
    final double dialogHeight = (screenSize.height * 0.72).clamp(420.0, 620.0);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: dialogWidth > 420.w ? 420.w : dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: PageView.builder(
                  itemCount: _visiblePopups.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final PopupModel popup = _visiblePopups[index];
                    return Material(
                      color: const Color(0xFFF8FAFC),
                      child: InkWell(
                        key: ValueKey<String>('popup-image-${popup.key}'),
                        onTap:
                            popup.hasExternalLink
                                ? () => _launchExternal(popup.linkUrl!)
                                : null,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.network(
                              popup.resolvedImageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, progress) =>
                                      progress == null
                                          ? child
                                          : const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF00649B),
                                            ),
                                          ),
                              errorBuilder:
                                  (_, __, ___) => const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 64,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                            ),
                            if (popup.hasExternalLink)
                              Positioned(
                                right: 14.w,
                                bottom: 14.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.62),
                                    borderRadius: BorderRadius.circular(99.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 7.h,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          '자세히 보기',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.open_in_new_rounded,
                                          size: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_visiblePopups.length > 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _visiblePopups.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: index == _currentIndex ? 18.w : 7.w,
                      height: 7.w,
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color:
                            index == _currentIndex
                                ? const Color(0xFF00649B)
                                : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                ),
              ),
            const Divider(height: 1),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF00649B),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () async {
                      await widget.onHideToday();
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('오늘 하루 보지 않기'),
                  ),
                ),
                Container(
                  width: 1,
                  height: 48.h,
                  color: const Color(0xFFE5E7EB),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF00649B),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () {
                      widget.onClose();
                      Navigator.pop(context);
                    },
                    child: const Text('닫기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchExternal(String url) async {
    final Future<void> Function(String url) launcher =
        widget.onLaunchExternal ?? UrlUtils.launchUrl;
    await launcher(url);
  }
}
