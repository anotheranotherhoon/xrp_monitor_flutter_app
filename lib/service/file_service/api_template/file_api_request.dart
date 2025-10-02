// ignore_for_file: invalid_annotation_target
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_api_request.freezed.dart';

enum Method {
  get,
  post,
  put,
  delete,
  head,
  patch,
  ;
}

extension GetMethod on Dio {
  Future<Response<T>> Function(String, {
  CancelToken? cancelToken,
  Object? data,
  Options? options,
  Map<String, dynamic>? queryParameters,
  }) method<T>(Method method) {
    return switch(method) {
      Method.get => get,
      Method.post => post,
      Method.put => put,
      Method.delete => delete,
      Method.head => head,
      Method.patch => patch,
    };
  }
}

@freezed
abstract class FileRequestOptions with _$FileRequestOptions {
  const factory FileRequestOptions({
    required Method method,
    required String path,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    @Default(freezed) Object? body,
    FormData? formData,
  }) = _FileRequestOptions;
}

/// Base class of requests
/// 해당 객체를 만들어 호출
mixin FileApiRequest {
  @JsonKey(includeFromJson: false, includeToJson: false)
  FileRequestOptions get requestMetadata;
}
