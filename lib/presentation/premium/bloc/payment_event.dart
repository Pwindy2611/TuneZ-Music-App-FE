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

class CheckPaymentStatus extends PaymentEvent {
  final String orderId;

  CheckPaymentStatus({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class PaymentFailed extends PaymentEvent {}

class ResetPaymentStateEvent extends PaymentEvent {}