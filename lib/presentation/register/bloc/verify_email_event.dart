import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

// Sự kiện bắt đầu xác minh email
class RegisterVerifyEmailEvent extends RegisterEvent {
  final String email;

  const RegisterVerifyEmailEvent(this.email);

  @override
  List<Object?> get props => [email];
}

// Sự kiện nhập OTP
class RegisterSubmitOtpEvent extends RegisterEvent {
  final String email;
  final String otp;

  const RegisterSubmitOtpEvent(this.otp, this.email);

  @override
  List<Object?> get props => [otp, email];
}

// Sự kiện tạo mật khẩu
class RegisterCreatePasswordEvent extends RegisterEvent {

  const RegisterCreatePasswordEvent();

  @override
  List<Object?> get props => [];
}

// Sự kiện nhập tên người dùng
class RegisterSubmitAccountEvent extends RegisterEvent {
  final String username;
  final String password;
  final String email;

  const RegisterSubmitAccountEvent(this.username,this.password, this.email);

  @override
  List<Object?> get props => [username, password, email];
  
}

class VerifyEmailEvent extends RegisterEvent {
  final String email;
  const VerifyEmailEvent(this.email);
  @override
  List<Object?> get props => [email];
}
