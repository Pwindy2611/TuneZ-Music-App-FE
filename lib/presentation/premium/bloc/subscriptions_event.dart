import 'package:equatable/equatable.dart';

abstract class SubscriptionsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchSubscriptions extends SubscriptionsEvent {}