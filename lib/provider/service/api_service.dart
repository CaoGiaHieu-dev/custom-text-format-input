import 'package:dio/dio.dart';

abstract class StorageProvider {
  void writeValue(String key, dynamic value);
  T readValue<T>(String key, T defaultValue);
}

class PrefConstants {
  static const String prefAuth = 'BaseUseCase._AccessTokenKey';
}

class ApiAuthorization extends Interceptor {
  final StorageProvider storageProvider;

  ApiAuthorization(this.storageProvider);

  String? _getAuthorization() {
    String token = storageProvider.readValue(PrefConstants.prefAuth, '');
    if (token == '') {
      return null;
    }
    String bearerToken = 'Bearer $token';

    return bearerToken;
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? strAuthorization = _getAuthorization();

    String? currentCustomToken = options.headers['Authorization'] as String?;
    if (currentCustomToken == null || currentCustomToken == '') {
      if (strAuthorization != null) {
        options.headers['Authorization'] = _getAuthorization();
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }
}
