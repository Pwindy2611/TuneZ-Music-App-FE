import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class BuildPremiumStudentFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 31, 31, 31),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 40),
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
                    "Student",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.studentPremium),
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
                        TextSpan(text: '29.500 '),
                        TextSpan(
                          text: 'đ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: ' cho 2 tháng \n',
                        ),
                        TextSpan(
                            text: 'Sau đó là 29.500 ',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.focusInput,
                                fontWeight: FontWeight.normal)),
                        TextSpan(
                          text: 'đ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              color: AppColors.focusInput,
                              fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                            text: '/tháng.',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.focusInput,
                                fontWeight: FontWeight.normal)),
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
                        TextSpan(text: "• 1 tài khoản Premium đã xác minh\n"),
                        TextSpan(
                            text: "• Giảm giá cho sinh viên đủ điều kiện\n"),
                        TextSpan(text: "• Hủy bất cứ lúc nào \n"),
                        TextSpan(text: "• Đăng ký hoặc thanh toán một lần"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BasicAppButton(
                    onPressed: () {},
                    title: "Mua Premium Student",
                    height: 20,
                    colors: Colors.black,
                    icon: null,
                    btnColor: AppColors.studentPremium,
                    textSize: 16,
                    padding: 16,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity, // Chiếm toàn bộ chiều ngang
                    child: RichText(
                      textAlign: TextAlign.center, // Căn giữa,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: '29.500 '),
                          TextSpan(
                            text: "đ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' cho 2 tháng, sau đó là 29.500 '),
                          TextSpan(
                            text: "đ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                              text:
                                  '/tháng. Ưu đãi chỉ dành cho sinh viên các trường đại học và cao đẳng được công nhận và nếu bạn chưa từng dùng gói Premium. '),
                          TextSpan(
                            text: "Có áp dụng điều khoản",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.studentPremium,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)), // Bo góc 8px
          ),
          padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8), // Thêm padding để nội dung không bị sát viền
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
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
                  text: ' cho 2 tháng',
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
