import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_event.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiService apiService;
  RegisterBloc(this.apiService) : super(RegisterInitialState()) {
    on<RegisterVerifyEmailEvent>(_onVerifyOtp);
    on<RegisterSubmitOtpEvent>(_onSubmitOtp);
    on<RegisterCreatePasswordEvent>(_onCreatePassword);
    on<RegisterSubmitAccountEvent>(_onSubmitAccount);
    on<VerifyEmailEvent>(_onVerifyEmail);
  }

  // Xử lý sự kiện xác minh email
  Future<void> _onVerifyOtp(
      RegisterVerifyEmailEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      final res = await apiService.post(
        'users/sendOtpEmail',
        {'email': event.email},
      );
      if (res['success'] == true) {
        emit(RegisterOtpState());
      } else {
        emit(RegisterErrorState("Lỗi email is required"));
      }
    } catch (e) {
      emit(RegisterErrorState("Lỗi khi xác minh email: ${e.toString()}"));
    }
  }

  // Xử lý sự kiện nhập OTP
  Future<void> _onSubmitOtp(
      RegisterSubmitOtpEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      final res = await apiService.post(
        'users/verifyOtp',
        {'email': event.email, "otp": event.otp},
      );
      if (res['success'] == true) {
        emit(RegisterEmailVerifiedState());
      } else {
        emit(RegisterErrorState("Lỗi khi xác minh email"));
      }
    } catch (e) {
      emit(RegisterErrorState("OTP không hợp lệ"));
    }
  }

  // Xử lý sự kiện tạo mật khẩu
  Future<void> _onCreatePassword(
      RegisterCreatePasswordEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      emit(RegisterPasswordState());
    } catch (e) {
      emit(RegisterErrorState("Không thể tạo mật khẩu"));
    }
  }

  // Xử lý sự kiện nhập tên người dùng
  Future<void> _onSubmitAccount(
      RegisterSubmitAccountEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      final res = await apiService.post(
        'users/register',
        {
          'email': event.email,
          "password": event.password,
          "username": event.username
        },
      );
      if (res['success'] == true) {
        emit(RegisterCompletedState());
      } else {
        emit(RegisterErrorState("Lỗi tạo tài khoản"));
      }
    } catch (e) {
      emit(RegisterErrorState("Không thể hoàn tất đăng ký ${e.toString()} "));
    }
  }

  Future<void> _onVerifyEmail(
      VerifyEmailEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      final res = await apiService.post(
        'users/sendEmailVerify',
        {'email': event.email},
      );
      if (res['success'] == true) {
        emit(VerifyEmailState());
      } else {
        emit(RegisterErrorState("Lỗi email is required"));
      }
    } catch (e) {
      emit(RegisterErrorState("Lỗi khi xác minh email: ${e.toString()}"));
    }
  }
}
