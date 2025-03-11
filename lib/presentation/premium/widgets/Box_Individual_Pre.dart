import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/common/widgets/button/basic_outline_button.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/premium/widgets/Dialog_Bottom_Pre.dart';

class BuildPremiumIndividualFeatures extends StatelessWidget {
  const BuildPremiumIndividualFeatures({super.key});

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
                    "Individual",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.individualPremium),
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
                        TextSpan(text: '59.000 '),
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
                            text: 'Sau đó là 59.000 ',
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
                        TextSpan(text: "• 1 tài khoản Premium\n"),
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
                    title: "Mua Premium Individual",
                    height: 20,
                    colors: Colors.black,
                    icon: null,
                    btnColor: AppColors.individualPremium,
                    textSize: 16,
                    padding: 16,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BasicAppOlButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // Cho phép chiều cao linh hoạt
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        builder: (context) => PaymentBottomDialog(),
                      );
                    },
                    title: "Thanh toán một lần",
                    height: 50,
                    colors: Colors.white,
                    icon: null,
                    outlineColor: Colors.white,
                    textSize: 16,
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
                          TextSpan(text: '59.000 '),
                          TextSpan(
                            text: "đ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' cho 2 tháng, sau đó là 59.000 '),
                          TextSpan(
                            text: "đ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                              text:
                                  '/tháng. Chỉ áp dụng ưu đãi nếu bạn chưa từng dùng gói Premium. '),
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
            color: AppColors.individualPremium,
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
