import "dart:async";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:tunezmusic/common/widgets/appBar/app_Bar_intro.dart";
import "package:tunezmusic/common/widgets/button/basic_button.dart";
import "package:tunezmusic/common/widgets/button/basic_outline_button.dart";
import "package:tunezmusic/core/configs/assets/app_images.dart";
import "package:tunezmusic/core/configs/assets/app_vectors.dart";
import "package:tunezmusic/core/configs/theme/app_colors.dart";
import "package:flutter/material.dart";
import "package:tunezmusic/data/services/bloc/auth_bloc.dart";
import "package:tunezmusic/data/services/bloc/auth_event.dart";
import "package:tunezmusic/data/services/bloc/auth_state.dart";
import "package:tunezmusic/presentation/login/pages/login_email.dart";
import "package:tunezmusic/presentation/register/pages/register_option.dart";

class LoginOptionPage extends StatelessWidget {
   LoginOptionPage({super.key});
  final StreamController<String> phoneNumberStreamController = StreamController<String>();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus(); // Hủy focus và đóng bàn phím
    }, child:  Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: IntroAppBar(),
        body:  Column(
                 mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50,),
                   Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                      AppVectors.logoBlack,
                      width: 100,
                      height: 100
                    )),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 50),
                      child:Text(
                      'Đăng nhập vào spotify',
                      textAlign: TextAlign.center ,
                      style: TextStyle(
                         fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                    ),
                    SizedBox(height: 60,),
                    Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding( padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ), child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      resByEmail(context),
                      SizedBox(height: 10,),
                      resByPhone(),
                      SizedBox(height: 10,),
                      resByGoogle(context),
                      SizedBox(height: 10,),
                      resByFacebook(),
                      SizedBox(height: 20,),
                      Text("Bạn chưa có tài khoản?", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 16)),
                      SizedBox(height: 20,),
                      navigateRegister(context),
                      ],
                    ),
                  ))
                ]
              ),
        )
        );
  }

  Widget resByEmail(context){
    return BasicAppButton(
          title: 'Tiếp tục với email',
          btnColor: AppColors.primary,
          colors: Colors.black,
          icon: AppImages.emailIcon,
          onPressed: () {
             Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()
            ));
          },
          textSize: 17,
          height: 52,
        );
  }

  Widget resByPhone(){
    return BasicAppOlButton(
      title: 'Tiếp tục bằng số điện thoại',
      outlineColor: null,
      colors: Colors.white,
      icon: AppImages.phoneIcon,
      onPressed: () {},
      textSize: 17,
      height: 52,
    );
  }

  Widget resByGoogle(BuildContext context) {
  return BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthLoading) {
        // Hiển thị loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator(color: AppColors.primary)),
        );
      } else if (state is AuthSuccess) {
        // Đóng loading và điều hướng
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công!'))
        );
      } else if (state is AuthFailure) {
        // Đóng loading và hiển thị lỗi
        Navigator.pop(context);
        if (kDebugMode) {
          print(state.error);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error))
        );
      }
    },
    builder: (context, state) {
      return BasicAppOlButton(
        title: 'Tiếp tục bằng Google',
        outlineColor: null,
        colors: Colors.white,
        icon: AppImages.googleIcon,
        onPressed: () {
          context.read<AuthBloc>().add(SignInWithGoogle());
        },
        textSize: 17,
        height: 52,
      );
    },
  );
}

  Widget resByFacebook(){
    return BasicAppOlButton(
      title: 'Tiếp tục bằng Facebook',
      outlineColor: null,
      colors: Colors.white,
      icon: AppImages.facebookIcon,
      onPressed: () {},
      textSize: 17,
      height: 52,
    );
  }

  Widget navigateRegister(context){
     return BasicAppButton(
          title: 'Đăng ký',
          btnColor: AppColors.darkBackground,
          colors: Colors.white,
          icon: null,
          onPressed: () {
                Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => RegisterOptionPage()
            ));
          },
          textSize: 14,
          height: 52,
        );
  }
}
