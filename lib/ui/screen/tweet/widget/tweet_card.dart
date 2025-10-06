import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:xrp_monitor/core/services/tweet/models/tweet_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
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
                        '@${tweet.authorId}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.w,
                        ),
                      ),
                      Text(
                        _formatDate(tweet.createdAt),
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
              tweet.text,
              style: TextStyle(
                fontSize: 14.w,
                height: 1.4.w,
              ),
            ),
            if (tweet.lang.isNotEmpty) ...[
              SizedBox(height: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: CommonColors.grey200,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  tweet.lang.toUpperCase(),
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
    );
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