import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;
  late PersistCookieJar _cookieJar;
  final Completer<void> _initCompleter = Completer<void>();

  factory ApiService() => _instance; // Singleton instance

  ApiService._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _initCookieJar(); // Đảm bảo _cookieJar khởi tạo hoàn tất

      _dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        baseUrl: dotenv.env['FLUTTER_PUBLIC_API_ENDPOINT'] ?? '',
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status <= 500,
      ));

      _dio.interceptors.add(CookieManager(_cookieJar)); // Thêm CookieManager

      _initCompleter.complete(); // Hoàn thành khởi tạo
    } catch (e) {
      _initCompleter.completeError(e); // Báo lỗi nếu có vấn đề
    }
  }

  Future<void> ensureInitialized() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
  }

  /// Khởi tạo CookieJar và đảm bảo lưu cookie vĩnh viễn
  Future<void> _initCookieJar() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      _cookieJar = PersistCookieJar(storage: FileStorage('${appDocDir.path}/cookies'));
    } catch (e) {
      throw Exception('Lỗi khởi tạo CookieJar: $e');
    }
  }

  /// Phương thức GET
  Future<dynamic> get(String endpoint) async {
    await ensureInitialized();
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error GET: $e');
    }
  }

  /// Phương thức POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    await ensureInitialized();
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Phương thức POST login (lưu cookie)
  Future<dynamic> postWithCookies(String endpoint, Map<String, dynamic> body) async {
    await ensureInitialized();
    try {
      final response = await _dio.post(endpoint, data: jsonEncode(body));

      // Nếu login thành công, lưu cookie vào bộ nhớ
      if (endpoint == 'users/login') {
        final uri = Uri.parse(_dio.options.baseUrl);
        final cookies = await _cookieJar.loadForRequest(uri);
        await _cookieJar.saveFromResponse(uri, cookies);
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Kiểm tra cookie đã lưu
  Future<List<Cookie>> getCookies(String url) async {
    await ensureInitialized();
    return _cookieJar.loadForRequest(Uri.parse(url));
  }

  /// Xử lý phản hồi HTTP
  dynamic _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception('HTTP Error: ${response.statusCode}, Body: ${response.data}');
    }
  }

  Future<void> clearCookies() async {
    await ensureInitialized();
    await _cookieJar.deleteAll(); // Xóa tất cả cookie
  }
}
