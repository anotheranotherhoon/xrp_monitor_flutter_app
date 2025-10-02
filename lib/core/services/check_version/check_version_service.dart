// import 'dart:convert';
// import 'dart:io' show Platform;
//
//
// import 'package:http/http.dart' as http;
// import 'package:xrp_monitor/core/models/common/CheckVersionModel.dart';
//
// import 'base/api_constants.dart';
//
// class CheckVersionService {
//   static const String androidVersion = '1.0.0';
//   static const String iosVersion = '1.0.0';
//
//   Future<CheckVersionModel?> runCheckVersion() async {
//     String type = 'AOS';
//     String version = androidVersion;
//     if (Platform.isIOS) {
//       type = 'IOS';
//       version = iosVersion;
//     }
//     final url = Uri.parse('${ApiConstants.checkVersionApi}v1/version/check?veType=$type&veLatestVersion=$version');
//     final response = await http.get(url);
//     var body = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = {'code': -1, 'result': {}};
//       if (body.containsKey('result')) {
//         data['result'] = body['result'];
//       }
//       if (body.containsKey('code')) {
//         data['code'] = body['code'];
//       }
//       var checkVersion = CheckVersionModel.fromApiJson(data['result']['data']);
//       return checkVersion;
//     }
//     return CheckVersionModel(apiDomain: ApiConstants.apiDomain, releaseNote: '0.0.0', type: 1);
//   }
// }
