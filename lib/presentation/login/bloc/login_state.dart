import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu
class LoginInitialState extends LoginState {}

// Trạng thái đang tải (loading)
class LoginLoadingState extends LoginState {}

// Trạng thái xác minh email thành công
class LoginEmailState extends LoginState {}

// Trạng thái đăng ký hoàn tất
class LoginCompletedState extends LoginState {}

// Trạng thái lỗi
class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
