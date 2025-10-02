import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mutex/mutex.dart';

import 'file_api_request.dart';

/// 실제 호출
Future<Response?> _fileRequest(Dio dio, FileApiRequest request, { Options? options, Map<String, dynamic>? queryParameters }) async {
  try {
    final metadata = request.requestMetadata;

    final http = dio.method<Map<String, dynamic>>(metadata.method);

    final baseHeaders = options?.headers;
    final metadataHeaders = metadata.headers;
    final headers = {
      if (metadataHeaders != null)
        ...metadataHeaders,
      if (baseHeaders != null)
        ...baseHeaders,
    };

    final option = options?.copyWith(headers: headers) ?? Options(headers: headers);

    final metadataQuery = metadata.queryParameters;
    final query = {
      if (metadataQuery != null)
        ...metadataQuery,
      if (queryParameters != null)
        ...queryParameters,
    };

    final body = metadata.method == Method.get
        ? null
        : metadata.formData ??
        (metadata.body == freezed
            ? request
            : metadata.body)
    ;

    final future = http(
      metadata.path,
      data: body,
      options: option,
      queryParameters: query,
    );

    try {
      final response = await future;
      return response;
    } on DioException catch (e) {
      final response = e.response;
      if (response == null) {
        rethrow;
      }
      return response;
    }
  } catch (e, stack) {
    if (kDebugMode) {
      print(e);
      print(stack);
    }
    return null;
  }
}

/// 메소드로 호출
extension CallApiRequest on FileApiRequest {
  Future<Response?> invoke(Dio dio, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    Mutex? lock,
  }) => fileRequest(dio, this, options: options, queryParameters: queryParameters, lock: lock);
}

/// Mutex 관리
Future<Response?> fileRequest(Dio dio, FileApiRequest request, { Options? options, Map<String, dynamic>? queryParameters, Mutex? lock }) async {
  if (lock != null) {
    return lock.protect(() async => _fileRequest(dio, request, options: options, queryParameters: queryParameters));
  } else {
    return _fileRequest(dio, request, options: options, queryParameters: queryParameters);
  }
}

extension StatusCodeCategory on int {
  bool get is100 => 100 <= this && this < 200;
  bool get is200 => 200 <= this && this < 300;
  bool get is300 => 300 <= this && this < 400;
  bool get is400 => 400 <= this && this < 500;
  bool get is500 => 500 <= this && this < 600;
}