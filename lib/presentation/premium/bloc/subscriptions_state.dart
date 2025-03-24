import 'package:equatable/equatable.dart';

abstract class SubscriptionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {}

class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionsFailure extends SubscriptionsState {
  final String errorMessage;

  SubscriptionsFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class SubscriptionsLoaded extends SubscriptionsState {
  final List<dynamic> subscriptions;

  SubscriptionsLoaded({required this.subscriptions});

  @override
  List<Object?> get props => [subscriptions];
}
