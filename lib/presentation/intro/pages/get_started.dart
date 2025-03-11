import 'package:flutter/material.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/presentation/login/pages/login_option.dart';
import 'package:tunezmusic/presentation/register/pages/register_option.dart';
class GetStartedPage extends StatelessWidget {
  const GetStartedPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    const Color.fromARGB(255, 58, 58, 58), 
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                 mainAxisSize: MainAxisSize.min,
                children: [
                   Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                      AppVectors.logoTuneZWhite,
                      width: 100,
                      height: 100
                    )),
                    SizedBox(height:5,),
                     Text(
                      'Hàng triệu bài hát.',
                      style: TextStyle(
                         fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                    Text(
                      'Miễn phí trên TuneZ.',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                    SizedBox(height: 120,),
                ]
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding( padding: const EdgeInsets.symmetric(
                vertical: 60,
                horizontal: 20,
              ), child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 registerButton(context),
                 SizedBox(height: 10,),
                 loginButton(context),
                ],
              ),
            ))
        ],
      )
    );
  }

  Widget registerButton(context) {
    return BasicAppButton(
          title: 'Đăng ký miễn phí',
          btnColor: AppColors.primary,
          colors: Colors.black,
          icon:null,
          onPressed: () {
             Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => RegisterOptionPage()
            ));
          },
          textSize: 17,
          height: 52,
        );
      }
  
  Widget loginButton(context) {
  return BasicAppOlButton(
    title: 'Đăng nhập',
    outlineColor: null,
    colors: Colors.white,
    icon: null,
    onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginOptionPage()
          ));
      },
      textSize: 17,
      height: 52,
    );
  }
}