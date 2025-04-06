import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectPayment extends PaymentEvent {
  final String itemId;
  final int amount;
  final String paymentMethod;

  SelectPayment({
    required this.itemId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [itemId, amount, paymentMethod];
}

// Xử lý callback sau khi thanh toán từ Momo
class HandlePaymentCallback extends PaymentEvent {
  final Map<String, dynamic> callbackData;

  HandlePaymentCallback({required this.callbackData});

  @override
  List<Object?> get props => [callbackData];
}


class ResetPaymentStateEvent extends PaymentEvent {}