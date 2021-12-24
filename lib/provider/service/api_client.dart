import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:inputformat/provider/service/api_config.dart';

enum ApiMethod { get, post, put, delete, path }

class ApiClient {
  ApiClient.init(this.apiConfig) {
    _setDio();
  }
  final ApiConfig apiConfig;
  static late final Dio dio;
  static late final DioCacheManager? dioCacheManager;
  void _setDio() {
    dio = apiConfig.createDio();
    dioCacheManager = apiConfig.dioCacheManager;
  }

  static Future<void> clearCache({String? url, ApiMethod? method}) async {
    if (url == null) {
      await dioCacheManager?.clearAll();
    } else if (method != null) {
      switch (method) {
        case ApiMethod.get:
          await dioCacheManager?.deleteByPrimaryKey(url, requestMethod: 'GET');
          break;
        case ApiMethod.post:
          await dioCacheManager?.deleteByPrimaryKey(url, requestMethod: 'POST');
          break;
        default:
          await dioCacheManager?.deleteByPrimaryKey(url);
      }
    } else {
      await dioCacheManager?.deleteByPrimaryKey(url);
    }
  }

  static Future<Response> connect(
    ApiMethod method,
    String url, {
    Map<String, String>? headers,
    Map<String, String>? query,
    Map<String, dynamic>? body,
    FormData? data,
    bool forceRefresh = true,
    Duration cacheTime = const Duration(days: 7),
    Duration maxStale = const Duration(days: 10),
    CancelToken? cancelToken,
    Function(DioError? error)? onError,
  }) async {
    try {
      Response response;
      log('url: $url');
      log('query: $query');
      log('method: $method');
      switch (method) {
        case ApiMethod.get:
          response = await dio.get(
            url,
            options: buildCacheOptions(cacheTime,
                forceRefresh: forceRefresh, maxStale: maxStale),
            queryParameters: query,
            cancelToken: cancelToken,
          );
          break;
        case ApiMethod.post:
          response = await dio.post(
            url,
            options: buildCacheOptions(cacheTime,
                forceRefresh: forceRefresh, maxStale: maxStale),
            queryParameters: query,
            data: data ?? body,
            cancelToken: cancelToken,
          );
          break;
        case ApiMethod.delete:
          response = await dio.delete(
            url,
            options: buildCacheOptions(cacheTime,
                forceRefresh: forceRefresh, maxStale: maxStale),
            queryParameters: query,
            cancelToken: cancelToken,
          );
          break;
        default:
          response = await dio.get(
            url,
            options: buildCacheOptions(cacheTime,
                forceRefresh: forceRefresh, maxStale: maxStale),
            queryParameters: query,
            cancelToken: cancelToken,
          );
          break;
      }
      return response;
    } on DioError catch (error) {
      log(error.toString());
      onError?.call(error);
      throw _errorHandle(error: error);
    }
  }
}

Map<String, dynamic> _errorHandle({DioError? error}) {
  var message = 'unknown_error';

  Map<String, dynamic>? data;

  switch (error?.type) {
    case DioErrorType.sendTimeout:
    case DioErrorType.receiveTimeout:
      message = 'request_time_out';
      break;
    case DioErrorType.response:
      if (error?.response?.data is Map<String, dynamic>) {
        data = error?.response?.data as Map<String, dynamic>;
        message = data['message'] as String;
      }
      break;
    case DioErrorType.cancel:
      message = "Cancel";
      break;
    default:
      message = 'Server đang bảo trì vui lòng thử lại sau';
      break;
  }
  return <String, dynamic>{
    'success': false,
    'message': message,
    'data': data,
  };
}
