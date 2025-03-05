import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/core/configs/assets/app_images.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/premium/widgets/Box_Individual_Pre.dart';
import 'package:tunezmusic/presentation/premium/widgets/Box_Mini_Pre.dart';
import 'package:tunezmusic/presentation/premium/widgets/Box_Student_Pre.dart';
import 'package:tunezmusic/presentation/premium/widgets/Box_info_Pre.dart';

class PremiumWidget extends StatefulWidget {
  const PremiumWidget({super.key});

  @override
  State<PremiumWidget> createState() => _PremiumWidgetState();
}

class _PremiumWidgetState extends State<PremiumWidget> {
  double _scale = 1;

  void _onScroll(double scrollOffset) {
    // Giới hạn thu nhỏ của ảnh nền (tối thiểu 1.0)
    double newScale = 1 - (scrollOffset / 500).clamp(0.0, 0.7);
    setState(() {
      _scale = newScale.clamp(0.1, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= 0) {
            _onScroll(scrollInfo.metrics.pixels);
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Transform.scale(
                    scale: _scale,
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color.fromARGB(255, 17, 17, 17),
                            Color.fromARGB(255, 31, 31, 31),
                            Color.fromARGB(255, 108, 108, 108),
                          ],
                        ),
                      ),
                      child: Transform.translate(
                        offset: Offset(-50, 0), // Dịch ảnh sang trái 50px
                        child: Transform.scale(
                          scale: 1.3, // Phóng to ảnh dựa theo cuộn
                          child: Image.asset(
                            AppImages.backgroundPremium,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 350,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(40, 0, 0, 0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppVectors.logoBlack,
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Premium",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Nghe không giới hạn. Dùng thử gói Premium trong 2 tháng với giá 59.000 ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'đ',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        color: Color.fromARGB(255, 15, 15, 15),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BasicAppButton(
                              onPressed: () {},
                              title: "Mua Premium Individual",
                              height: 20,
                              colors: Colors.black,
                              icon: null,
                              btnColor: Colors.white,
                              textSize: 16,
                              padding: 16,
                            ),
                            SizedBox(height: 20),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: [
                                  TextSpan(text: '59.000 '),
                                  TextSpan(
                                    text: 'đ',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                      text: ' cho 2 tháng, sau đó là 59.000 '),
                                  TextSpan(
                                    text: 'đ',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '/tháng. Chỉ áp dụng ưu đãi nếu bạn chưa từng dùng gói Premium.',
                                  ),
                                  TextSpan(
                                    text: ' Có áp dụng điều khoản.',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            BuildPremiumFeatures(),
                            SizedBox(height: 30),
                            Text(
                              "Các gói có sẵn",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 25),
                            BuildPremiumMiniFeatures(),
                            SizedBox(height: 25),
                            BuildPremiumIndividualFeatures(),
                            SizedBox(height: 25),
                            BuildPremiumStudentFeatures(),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
