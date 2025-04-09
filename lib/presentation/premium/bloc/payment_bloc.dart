import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ApiService apiService;
  String? _currentItemId;

  PaymentBloc(this.apiService) : super(PaymentInitial()) {
    on<SelectPayment>(_onSelectSubscription);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<PaymentFailed>(_onPaymentFailed);
    on<ResetPaymentStateEvent>(_onResetState);
  }

    Future<void> _onSelectSubscription(
    SelectPayment event, Emitter<PaymentState> emit) async {
  emit(PaymentLoading());
  try {
    final response = await apiService.postWithCookies(
      'payment/create',
      {
        "itemId": event.itemId,
        "amount": event.amount,
        "paymentMethod": event.paymentMethod,
      },
    );
    print("payment"+response.toString());
    if (response["status"] == 201) {
      final deepLink = response["data"]["metadata"]["deeplink"];
      print(deepLink);
      emit(PaymentSuccess(paymentUrl: deepLink));

      // Mở Momo app bằng deeplink
      _openDeepLink(deepLink);
    } else {
      emit(PaymentFailure(errorMessage: "Lỗi khi tạo đơn hàng"));
    }
  } catch (e) {
    print( "Lỗi kết nối: $e");
    emit(PaymentFailure(errorMessage: "Lỗi kết nối: $e"));
  }
}

Future<void> _openDeepLink(String url) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: url,
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      print("Không thể mở deeplink bằng Intent: $e");
    }
  }
}

  // Thêm phương thức xử lý deep link 
  void handleDeepLink(Uri uri) {
    if (uri.scheme == 'tunezmusic' && uri.host == 'payment-callback') {
      final status = uri.queryParameters['status'];
      final orderId = uri.queryParameters['orderId'];
      
      if (status == 'success' && orderId != null) {
        add(CheckPaymentStatus(orderId: orderId));
      } else {
        add(PaymentFailed());
      }
    }
  }

  Future<void> _onCheckPaymentStatus(
      CheckPaymentStatus event, Emitter<PaymentState> emit) async {
    try {
      emit(PaymentLoading());
      final response = await apiService.get(
        'payments/checkPaymentStatus/${event.orderId}',
      );

      if (response?.statusCode == 200) {
        final data = response?.data;
        if (data['status'] == 'success') {
          emit(PaymentSuccess(paymentUrl: ''));
        } else {
          emit(PaymentError('Thanh toán thất bại'));
        }
      } else {
        emit(PaymentError('Kiểm tra trạng thái thanh toán thất bại'));
      }
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onPaymentFailed(
      PaymentFailed event, Emitter<PaymentState> emit) async {
    emit(PaymentError('Thanh toán thất bại'));
  }

  void _onResetState(ResetPaymentStateEvent event, Emitter<PaymentState> emit) {
    emit(PaymentInitial());
  }
}
