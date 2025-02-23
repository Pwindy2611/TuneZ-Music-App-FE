import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['FLUTTER_PUBLIC_API_ENDPOINT'] ?? '';

  /// Phương thức GET
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(url);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error GET: $e');
    }
  }

  /// Phương thức POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error POST: $e');
    }
  }

  /// Phương thức PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error PUT: $e');
    }
  }

  /// Phương thức DELETE
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.delete(url);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error DELETE: $e');
    }
  }

  /// Xử lý phản hồi HTTP
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'HTTP Error: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}
