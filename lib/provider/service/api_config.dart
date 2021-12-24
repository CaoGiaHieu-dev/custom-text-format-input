import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class ApiConfig {
  ApiConfig({
    this.interceptor = const [],
    this.responseType = ResponseType.json,
    this.customHeader,
    this.baseUrl,
    this.sendTimeout = 2000,
    this.connectTimeout = 10000,
    this.receiveTimeout = 10000,
    this.cacheData = false,
  });

  final List<Interceptor> interceptor;
  final ResponseType responseType;
  final Map<String, String>? customHeader;
  final String? baseUrl;
  final int sendTimeout, connectTimeout, receiveTimeout;
  final bool cacheData;
  late final DioCacheManager? dioCacheManager;
  Dio createDio() {
    final dio = Dio();
    customHeader?.addToHeader(dio);
    dio.options.sendTimeout = sendTimeout;
    dio.options.connectTimeout = connectTimeout;
    dio.options.receiveTimeout = receiveTimeout;
    if (baseUrl != null) {
      dio.options.baseUrl = baseUrl!;
    }

    dio.interceptors.addAll(interceptor);
    if (cacheData) {
      dioCacheManager = DioCacheManager(CacheConfig(baseUrl: baseUrl));
      dio.interceptors.add(dioCacheManager?.interceptor);
    }

    return dio;
  }
}

extension MapToDioOption on Map<String, String> {
  void addToHeader(Dio dio) {
    if (isNotEmpty) {
      entries.map((e) => dio.options.headers[e.key] = e.value);
    }
  }
}
