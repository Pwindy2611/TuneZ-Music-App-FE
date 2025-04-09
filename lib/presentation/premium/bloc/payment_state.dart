import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}


class PaymentInitial extends PaymentState {}


class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String? paymentUrl; // URL để chuyển hướng qua Momo, có thể null

  PaymentSuccess({this.paymentUrl});

  @override
  List<Object?> get props => [paymentUrl];
}


class PaymentFailure extends PaymentState {
  final String errorMessage;

  PaymentFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
