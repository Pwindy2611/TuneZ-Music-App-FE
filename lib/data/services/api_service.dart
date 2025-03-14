import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  late CookieJar _cookieJar;

  factory ApiService() {
    return _instance; // Luôn trả về cùng một instance
  }

  ApiService._internal() {
    _cookieJar = CookieJar(); // Chỉ tạo 1 lần duy nhất

    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      baseUrl: dotenv.env['FLUTTER_PUBLIC_API_ENDPOINT'] ?? '',
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null && status <= 500;
      },
    ));

    _dio.interceptors
        .add(CookieManager(_cookieJar)); // Thêm CookieManager vào _dio
  }

  /// Phương thức GET (có cookie)
  Future<dynamic> get(String endpoint) async {
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final response = await _dio.get(endpoint,
          options: Options(headers: {'Cookie': cookieHeader}));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error GET: $e');
    }
  }

  /// Phương thức POST (có cookie)
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
      final cookieHeader =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
      final response = await _dio.post(endpoint,
          data: jsonEncode(body),
          options: Options(headers: {'Cookie': cookieHeader}));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Phương thức POST login (lưu cookie)
  Future<dynamic> postWithCookies(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(body));

      // Nếu login thành công, lưu cookie lại
      if (endpoint == 'users/login') {
        _cookieJar.saveFromResponse(Uri.parse(_dio.options.baseUrl),
            await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl)));
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Kiểm tra cookie đã lưu
  Future<List<Cookie>> getCookies(String url) async {
    final uri = Uri.parse(url);
    return await _cookieJar.loadForRequest(uri);
  }

  /// Xử lý phản hồi HTTP
  dynamic _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception(
          'HTTP Error: ${response.statusCode}, Body: ${response.data}');
    }
  }
}
