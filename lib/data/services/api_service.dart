import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiService {
  late Dio _dio;
  late CookieJar _cookieJar;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['FLUTTER_PUBLIC_API_ENDPOINT'] ?? '',
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null && status <= 500; // Chỉ ném lỗi nếu status >= 500
      },
    ));

    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  /// Phương thức GET
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error GET: $e');
    }
  }

  /// Phương thức POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Phương thức PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(endpoint, data: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error PUT: $e');
    }
  }

  /// Phương thức DELETE
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error DELETE: $e');
    }
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

  /// Kiểm tra cookie đã lưu
  Future<List<Cookie>> getCookies(String url) async {
    final uri = Uri.parse(url);
    return await _cookieJar.loadForRequest(uri);
  }
}
