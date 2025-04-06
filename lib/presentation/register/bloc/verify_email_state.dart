import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu
class RegisterInitialState extends RegisterState {}

// Trạng thái đang tải (loading)
class RegisterLoadingState extends RegisterState {}

// Trạng thái xác minh email thành công
class RegisterEmailVerifiedState extends RegisterState {}

// Trạng thái nhập OTP
class RegisterOtpState extends RegisterState {}

// Trạng thái tạo mật khẩu
class RegisterPasswordState extends RegisterState {}

// Trạng thái đăng ký hoàn tất
class RegisterCompletedState extends RegisterState {}

class VerifyEmailState extends RegisterState {}
// Trạng thái lỗi
class RegisterErrorState extends RegisterState {
  final String message;

  const RegisterErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
