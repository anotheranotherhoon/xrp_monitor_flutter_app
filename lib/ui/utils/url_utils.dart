import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UrlUtils {
  UrlUtils._();

  static Future<void> launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);
    }
  }

  static Future<void> launchUrlInApp(String url) async {
    final Uri uri = Uri.parse(url);
    if (await url_launcher.canLaunchUrl(uri)) {
      await url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.inAppWebView);
    }
  }

  static Future<bool> canLaunch(String url) async {
    final Uri uri = Uri.parse(url);
    return await url_launcher.canLaunchUrl(uri);
  }
}