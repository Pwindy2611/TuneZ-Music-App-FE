import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/presentation/login/pages/login_email.dart';
class VerifyEmail extends StatelessWidget {
  const VerifyEmail ({super.key});

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
                      AppVectors.logoBlack,
                      width: 100,
                      height: 100
                    )),
                     Text(
                      'Kiểm tra Email của bạn',
                      style: TextStyle(
                         fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 28
                      ),
                    ),
                    Text(
                      'Xác thực tài khoản của bạn',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 28
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 backButton(context),
                ],
              ),
            ))
        ],
      )
    );
  }
  
  Widget backButton(context) {
  return BasicAppOlButton(
    title: 'Đăng nhập',
    outlineColor: null,
    colors: Colors.white,
    icon: null,
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
}