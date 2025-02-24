 import 'dart:convert';

import 'package:flutter/foundation.dart';

String extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception("Token không hợp lệ");
      }
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decodedJson = jsonDecode(payload);
      return decodedJson['uid'] ?? ''; // Lấy userId từ payload
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi khi giải mã token: ${e.toString()}");
      }
      return '';
    }
  }