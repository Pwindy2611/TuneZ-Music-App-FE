import "dart:async";
import "package:flutter_svg/svg.dart";
import "package:tunezmusic/common/widgets/appBar/app_Bar_intro.dart";
import "package:tunezmusic/common/widgets/button/basic_button.dart";
import "package:tunezmusic/common/widgets/button/basic_outline_button.dart";
import "package:tunezmusic/core/configs/assets/app_images.dart";
import "package:tunezmusic/core/configs/assets/app_vectors.dart";
import "package:tunezmusic/core/configs/theme/app_colors.dart";
import "package:flutter/material.dart";
import "package:tunezmusic/presentation/login/pages/login_option.dart";
import "package:tunezmusic/presentation/register/pages/register_email.dart";

class RegisterOptionPage extends StatelessWidget {
   RegisterOptionPage({super.key});
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
                     Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child:Text(
                      'Đăng ký để bắt đầu nghe',
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
                      resByGoogle(),
                      SizedBox(height: 10,),
                      resByFacebook(),
                      SizedBox(height: 20,),
                      Text("Bạn đã có tài khoản?", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 16)),
                      SizedBox(height: 20,),
                      navigateLogin(context),
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
              builder: (BuildContext context) => RegisterPage()
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

  Widget resByGoogle(){
    return BasicAppOlButton(
      title: 'Tiếp tục bằng Google',
      outlineColor: null,
      colors: Colors.white,
      icon: AppImages.googleIcon,
      onPressed: () {},
      textSize: 17,
      height: 52,
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

  Widget navigateLogin(context){
     return BasicAppButton(
          title: 'Đăng nhập',
          btnColor: AppColors.darkBackground,
          colors: Colors.white,
          icon: null,
          onPressed: () {
                Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginOptionPage()
            ));
          },
          textSize: 14,
          height: 52,
        );
  }
}
