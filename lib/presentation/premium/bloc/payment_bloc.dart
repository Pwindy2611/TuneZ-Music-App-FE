import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  ApiService apiService;

  PaymentBloc(this.apiService) : super(PaymentInitial()) {
    on<SelectPayment>(_onSelectSubscription);
    on<HandlePaymentCallback>(_onHandlePaymentCallback);
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

  Future<void> _onHandlePaymentCallback(
      HandlePaymentCallback event, Emitter<PaymentState> emit) async {
    if (event.callbackData["status"] == 400) {
      emit(PaymentFailure(errorMessage: "Thanh toán thất bại"));
    } else {
      emit(PaymentSuccess(paymentUrl: ""));
    }
  }
}
