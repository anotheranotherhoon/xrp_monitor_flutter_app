import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/core/services/twitter/models/twitter_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class TwitterCard extends StatelessWidget {
  final Twitter twitter;

  const TwitterCard({
    super.key,
    required this.twitter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: CommonColors.grey300,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        elevation: 2,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: InkWell(
        onTap: () => _openTweet(),
        borderRadius: BorderRadius.circular(12.w),
        child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.w,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: CommonColors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${twitter.authorId}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.w,
                        ),
                      ),
                      Text(
                        _formatDate(twitter.createdAt),
                        style: TextStyle(
                          color: CommonColors.grey600,
                          fontSize: 12.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.w),
            Text(
              twitter.text,
              style: TextStyle(
                fontSize: 14.w,
                height: 1.4.w,
              ),
            ),
            if (twitter.lang.isNotEmpty) ...[
              SizedBox(height: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: CommonColors.grey200,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  twitter.lang.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.w,
                    color: CommonColors.grey600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  Future<void> _openTweet() async {
    if (twitter.id.isEmpty) return;
    
    // X(트위터) 앱 URL 스키마들 시도
    final List<String> appUrls = [
      'twitter://status?id=${twitter.id}',  // 기존 트위터
      'x://status?id=${twitter.id}',        // 새로운 X 앱
    ];
    // 웹 URL (앱이 없는 경우)
    final String webUrl = 'https://twitter.com/i/web/status/${twitter.id}';
    
    try {
      // 앱 URL들을 순서대로 시도
      for (String appUrl in appUrls) {
        final uri = Uri.parse(appUrl);
        if (await canLaunchUrl(uri)) {
          final success = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (success) return; // 성공하면 종료
        }
      }
      
      // 모든 앱 URL이 실패한 경우 웹으로 열기
      await launchUrl(
        Uri.parse(webUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('${AppStrings.twitterOpenFailed}: $e');
    }
  }

  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      final Duration difference = DateTime.now().difference(date);
      
      if (difference.inDays > 7) {
        return DateFormat('MMM dd, yyyy').format(date);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'now';
      }
    } catch (e) {
      return dateStr;
    }
  }
}