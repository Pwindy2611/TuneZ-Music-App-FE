import 'dart:ui';

import 'package:flutter/widgets.dart';

class UrlHandlerService with WidgetsBindingObserver {
  static final UrlHandlerService _instance = UrlHandlerService._internal();

  factory UrlHandlerService() {
    return _instance;
  }

  UrlHandlerService._internal();

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("dsadasda");
      // Ứng dụng được mở lại, xử lý URL tại đây
      _handleIncomingUrl();
    }
  }

  void _handleIncomingUrl() {
    // Lấy URL từ `PlatformDispatcher` hoặc các phương pháp khác
    final initialLink = PlatformDispatcher.instance.defaultRouteName;
    print('URL được mở: $initialLink');
    // Thực hiện xử lý URL tại đây
    }
}