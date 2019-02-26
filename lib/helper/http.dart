import 'package:dio/dio.dart';

class RestApi {
  RestApi();

  static Dio _dio;
  static getDio([options]) {
    if (RestApi._dio != null) {
      return RestApi._dio;
    }
    Dio dio = new Dio(options);
    RestApi._dio = dio;
    return dio;
  }

  static Future post(url, [data]) async {
    return await RestApi.getDio().post(url, data: data);
  }

  static Future get(url, [data]) async {
    return await RestApi.getDio().get(url, queryParameters: data);
  }
}