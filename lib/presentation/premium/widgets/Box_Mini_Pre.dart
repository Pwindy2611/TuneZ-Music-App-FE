import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class BuildPremiumMiniFeatures extends StatelessWidget {
  const BuildPremiumMiniFeatures({super.key});
  @override
  Widget build(BuildContext context) {
  return Container(
    alignment: Alignment.topLeft,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 31, 31, 31),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppVectors.logoTuneZWhite,
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 5),
                Text(
                  "Premium",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Mini",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.miniPremium),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(text: '10.500 '),
                  TextSpan(
                    text: 'đ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' cho 1 tuần',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.darkGrey,
            ),
            SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.white),
                children: [
                  TextSpan(
                      text:
                          "• 1 tài khoản Premium chỉ dành cho thiết bị di động \n"),
                  TextSpan(
                      text:
                          "• Nghe tối đa 30 bài hát trên 1 thiết bị khi không có kết nối mạng \n"),
                  TextSpan(text: "• Thanh toán một lần \n"),
                  TextSpan(text: "• Chất lượng âm thanh cơ bản"),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            BasicAppButton(
              onPressed: () {},
              title: "Mua Premium Mini",
              height: 20,
              colors: Colors.black,
              icon: null,
              btnColor: AppColors.miniPremium,
              textSize: 16,
              padding: 16,
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity, // Chiếm toàn bộ chiều ngang
              child: Text(
                "Có áp dụng điều khoản",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center, // Căn giữa
              ),
            )
          ],
        )),
  );
}
}