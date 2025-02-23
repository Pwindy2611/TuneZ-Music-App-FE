import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_title.dart';
import 'package:tunezmusic/common/widgets/button/enable_button.dart';
import 'package:tunezmusic/common/widgets/input/input_password.dart';
import 'package:tunezmusic/common/widgets/input/input_intro.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/login/bloc/login_bloc.dart';
import 'package:tunezmusic/presentation/login/bloc/login_event.dart';
import 'package:tunezmusic/presentation/login/bloc/login_state.dart';
import 'package:tunezmusic/presentation/main/pages/mainpage.dart';
import 'package:tunezmusic/presentation/login/validation/login_validate.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  final isLoading = ValueNotifier(false);
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(ApiService()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            isLoading.value = true;
          } else if (state is LoginEmailState) {
            isLoading.value = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainPage()),
            );
          } else if (state is LoginErrorState) {
            isLoading.value = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: TitleAppBar(
            title: "Đăng nhập",
            titleColor: Colors.white,
            titleSize: 16,
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
                                    BlocProvider.of<LoginBloc>(context).add(
                                        LoginEmailEvent(emailController.text,
                                            passwordController.text));
                                    isButtonEnabled.value = false;
                                  }
                                : () {},
                            title: "Đăng nhập",
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
