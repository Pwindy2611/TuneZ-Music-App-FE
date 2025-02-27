import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/common/widgets/appBar/app_Bar_title.dart';
import 'package:tunezmusic/common/widgets/button/enable_button.dart';
import 'package:tunezmusic/common/widgets/input/input_intro.dart';
import 'package:tunezmusic/common/widgets/input/input_otp.dart';
import 'package:tunezmusic/common/widgets/input/input_password.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/data/services/api_service.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_bloc.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_event.dart';
import 'package:tunezmusic/presentation/register/bloc/verify_email_state.dart';
import 'package:tunezmusic/presentation/register/pages/verify_email_noti.dart';
import 'package:tunezmusic/presentation/register/validation/register_validate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  final isLoading = ValueNotifier(false);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      isButtonEnabled.value = validateEmail(emailController.text) == null;
    });
    passwordController.addListener(() {
      isButtonEnabled.value = validatePassword(passwordController.text) == null;
    });
    usernameController.addListener(() {
      isButtonEnabled.value = validateName(usernameController.text) == null;
    });
    for (var controller in otpControllers) {
      controller.addListener(_checkOtpValidation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(ApiService()),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoadingState) {
           isLoading.value = true;
          } else if (state is RegisterOtpState) {
            setState(() => _currentIndex = 1);
             isLoading.value = false;
          } else if (state is RegisterEmailVerifiedState) {
            setState(() => _currentIndex = 2);
             isLoading.value = false;
          } else if (state is RegisterPasswordState) {
            setState(() => _currentIndex = 3);
             isLoading.value = false;
          } else if (state is RegisterCompletedState) {
             isLoading.value = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => VerifyEmail()),
            );
          } else if (state is RegisterErrorState) {
            // Hiển thị thông báo lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
             isLoading.value = false;
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: TitleAppBar(
            title: "Tạo tài khoản",
            titleColor: Colors.white,
            titleSize: 16,
            bgColor: null,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildEmailStep(),
                _buildOtpStep(),
                _buildPasswordStep(),
                _buildUsernameStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Builder(
      builder: (context) {
        return _buildStep(
          title: "Email của bạn là gì?",
          inputWidget: BaseInputField(
            controller: emailController,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            fillColor: AppColors.darkGrey,
            hintText: '',
            validator: validateEmail,
          ),
          onNext: () {
            BlocProvider.of<RegisterBloc>(context)
                .add(RegisterVerifyEmailEvent(emailController.text));
            isButtonEnabled.value = false;
          },
        );
      },
    );
  }

  void _checkOtpValidation() {
    String otp = otpControllers.map((controller) => controller.text).join();
    isButtonEnabled.value = validateOtp(otp) == null;
  }

  Widget _buildOtpStep() {
    return Builder(builder: (context) {
      return Column(
        children: [
          _buildTitle("Nhập mã OTP đã gửi tới email"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (index) =>
                  OtpTextField(index: index, controllers: otpControllers),
            ),
          ),
          SizedBox(height: 30),
          _buildNextButton(() {
            final otp = otpControllers.map((c) => c.text).join();
            // Dispatch event OTP
            BlocProvider.of<RegisterBloc>(context)
                .add(RegisterSubmitOtpEvent(otp, emailController.text));
            isButtonEnabled.value = false;
          }),
        ],
      );
    });
  }

  Widget _buildPasswordStep() {
    return Builder(builder: (context) {
      return _buildStep(
        title: "Mật khẩu của bạn là gì?",
        inputWidget: PassInputField(
          controller: passwordController,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          fillColor: AppColors.darkGrey,
          hintText: '',
          validator: validatePassword,
        ),
        onNext: () {
          BlocProvider.of<RegisterBloc>(context)
              .add(RegisterCreatePasswordEvent());
          isButtonEnabled.value = false;
        },
      );
    });
  }

  Widget _buildUsernameStep() {
    return Builder(builder: (context) {
      return _buildStep(
        title: "Tên của bạn là gì?",
        inputWidget: BaseInputField(
          controller: usernameController,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          fillColor: AppColors.darkGrey,
          hintText: '',
          validator: validateName,
        ),
        onNext: () async {
           FocusManager.instance.primaryFocus?.unfocus();
          BlocProvider.of<RegisterBloc>(context).add(RegisterSubmitAccountEvent(
              usernameController.text,
              passwordController.text,
              emailController.text));
        },
        isFinalStep: true,
      );
    });
  }

  Widget _buildStep({
    required String title,
    required Widget inputWidget,
    required VoidCallback onNext,
    bool isFinalStep = false,
  }) {
    return Column(
      children: [
        _buildTitle(title),
        SizedBox(height: 20),
        inputWidget,
        SizedBox(height: 30),
        _buildNextButton(
          onNext,
          isFinalStep,
        ),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Center(
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            text,
            textStyle: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 26,
            ),
          ),
        ],
        repeatForever: false,
        isRepeatingAnimation: false,
      ),
    );
  }

  Widget _buildNextButton(VoidCallback onPressed, [bool isFinalStep = false]) {
  return ValueListenableBuilder<bool>(
    valueListenable: isLoading,
    builder: (context, loading, child) {
      return ValueListenableBuilder<bool>(
        valueListenable: isButtonEnabled,
        builder: (context, isEnabled, child) {
          return EnabledButton(
            isEnabled: isEnabled,
            onPressed: onPressed,
            isLoading: isLoading.value, // Truyền thẳng `isLoading`
            title: isFinalStep ? "Hoàn tất" : "Tiếp tục",
          );
        },
      );
    },
  );
}
}
