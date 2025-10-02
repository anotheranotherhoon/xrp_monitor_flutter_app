// import 'package:buster/third_parties/dio/firebase_crashlytics_interceptor.dart';
// import 'package:buster/third_parties/dio/local_log_interceptor.dart';
import 'package:dio/dio.dart';

Dio createFileDio([BaseOptions? options, List<Interceptor> interceptors = const []]) {
  final dio = Dio(options);

  dio.interceptors.addAll(interceptors);
  // dio.interceptors.add(const FirebaseCrashlyticsInterceptor());
  // dio.interceptors.add(const LocalLogInterceptor());

  return dio;
}