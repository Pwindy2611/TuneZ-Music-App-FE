import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}


class LoginEmailLoadingState extends LoginState {}

class LoginCompletedState extends LoginState {}

// Trạng thái lỗi
class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginGoogleLoadingState extends LoginState {}


class LoginFacebookLoadingState extends LoginState {}

class LoginFacebookErrorState extends LoginState {
   final String message;

  const LoginFacebookErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginGoogleErrorState extends LoginState {
   final String message;

  const LoginGoogleErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class DoVerifiedLoginState extends LoginState {}

class NewAccountState extends LoginState {}