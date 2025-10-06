import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class DefaultAlertDialog extends StatelessWidget {
  const DefaultAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.widgetContent = const [],
    this.confirmText = '확인',
    this.onTapCheck,
  });

  final String title;
  final String content;
  final String confirmText;
  final List<Widget> widgetContent;
  final void Function()? onTapCheck;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadowColor: Colors.transparent,
      backgroundColor: CommonColors.mainBlack,
      insetPadding: EdgeInsets.all(20.w),
      titlePadding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 16.w),
      contentPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      actionsPadding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 20.w),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.w600, color: CommonColors.white),
      ),
      contentTextStyle: TextStyle(
        fontSize: 14.w,
        color: CommonColors.white,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content.isNotEmpty)
            Text(
              content,
              textAlign: TextAlign.center,
            ),
          ...widgetContent,
        ],
      ),
      actions: [
        ElevatedButton(
          autofocus: true,
          onPressed: onTapCheck ?? Navigator.of(context).pop,
          child: Text(confirmText),
        ),
      ],
    );
  }
}