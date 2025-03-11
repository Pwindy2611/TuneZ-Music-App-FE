import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_title.dart';
import 'package:tunezmusic/common/widgets/button/enable_button.dart';
import 'package:tunezmusic/common/widgets/input/input_password.dart';
import 'package:tunezmusic/common/widgets/input/input_intro.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/artistSelection/pages/ArtistSelectionPage.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';
import 'package:tunezmusic/presentation/login/bloc/login_state.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';
import 'package:tunezmusic/presentation/login/validation/login_validate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  final ValueNotifier<bool> showForgotPassword = ValueNotifier(false);
  final ValueNotifier<int> countdown = ValueNotifier(0);
  final isLoading = ValueNotifier(false);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isEmailValid = validateEmail(emailController.text) == null;
    final isPasswordValid = validatePassword(passwordController.text) == null;

    isButtonEnabled.value = isEmailValid && isPasswordValid;
  }

  void _startCountdown() {
    countdown.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _sendResetPassword() async {
    final email = emailController.text;
    if (email.isEmpty || validateEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email không hợp lệ")),
      );
      return;
    }

    try {
      if (kDebugMode) {
        print(emailController.text);
      }
      final apiService = ApiService();
      await apiService.post(
          'users/sendEmailResetPassword', {"email": emailController.text});

      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email đặt lại mật khẩu đã được gửi")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gửi email thất bại")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isButtonEnabled.dispose();
    showForgotPassword.dispose();
    countdown.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginEmailLoadingState) {
          isLoading.value = true;
        } else if (state is LoginCompletedState) {
          isLoading.value = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainPage()),
          );
        } else if (state is LoginErrorState) {
          isLoading.value = false;
          showForgotPassword.value = true;
        } else if (state is NewAccountState){
          isLoading.value = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ArtistSelectionPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: TitleAppBar(
          title: "Đăng nhập",
          titleColor: Colors.white,
          titleSize: 16,
          bgColor: null,
          onBackPressed: () {
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
          }
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Đăng nhập vào tài khoản của bạn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              BaseInputField(
                controller: emailController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                fillColor: AppColors.darkGrey,
                hintText: 'Email',
                validator: validateEmail,
              ),
              SizedBox(height: 20),
              PassInputField(
                controller: passwordController,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                fillColor: AppColors.darkGrey,
                hintText: 'Mật khẩu',
                validator: validatePassword,
              ),
              SizedBox(height: 10),
              ValueListenableBuilder<int>(
                valueListenable: countdown,
                builder: (context, value, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: showForgotPassword,
                    builder: (context, show, child) {
                      return show
                          ? value == 0
                              ? GestureDetector(
                                  onTap: _sendResetPassword,
                                  child: Text(
                                    "Quên mật khẩu?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Gửi lại sau ${value}s",
                                  style: TextStyle(color: Colors.grey),
                                )
                          : SizedBox.shrink();
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isButtonEnabled,
                    builder: (context, isEnabled, child) {
                      return EnabledButton(
                        isEnabled: isEnabled,
                        isLoading: isLoading.value,
                        onPressed: isEnabled
                            ? () {
                              FocusManager.instance.primaryFocus?.unfocus();
                                BlocProvider.of<LoginBloc>(context).add(
                                  LoginEmailEvent(
                                    emailController.text,
                                    passwordController.text,
                                  ),
                                );
                                isButtonEnabled.value = false;
                              }
                            : () {},
                        title: "Đăng nhập",
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
