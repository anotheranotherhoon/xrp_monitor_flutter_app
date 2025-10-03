import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xrp_monitor/core/services/tweet/models/tweet_model.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({
    Key? key,
    required this.tweet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${tweet.authorId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(tweet.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tweet.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (tweet.lang.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tweet.lang.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
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