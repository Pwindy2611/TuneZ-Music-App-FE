import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email,password];
}

class SignInWithGoogleEvent extends LoginEvent {}

class SignInWithFacebookEvent extends LoginEvent{}

class ForgotPasswordEvent extends LoginEvent{}
