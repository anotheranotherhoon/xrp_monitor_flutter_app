import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: InkWell(
        onTap: () => UrlUtils.launchUrl(news.originalLink),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: news.title,
                style: {
                  "*": Style(
                    fontSize: FontSize(18.w),
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
              SizedBox(height: 8.w),
              Html(
                data: news.description,
                style: {
                  "*": Style(
                    fontSize: FontSize(14.w),
                    color: CommonColors.grey600,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
              SizedBox(height: 8.w),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.w,
                    color: CommonColors.grey600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    news.createdAt,
                    style: TextStyle(
                      fontSize: 12.w,
                      color: CommonColors.grey600,
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
