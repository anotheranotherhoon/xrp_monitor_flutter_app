import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    required this.news,
    super.key
  });

  final News news;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => UrlUtils.launchUrl(news.originalLink),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: news.title,
                style: {
                  "*": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
              const SizedBox(height: 8),
              Html(
                data: news.description,
                style: {
                  "*": Style(
                    fontSize: FontSize(14),
                    color: Colors.grey[600],
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    news.createdAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
