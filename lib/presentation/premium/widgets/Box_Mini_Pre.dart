import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tunezmusic/common/widgets/button/basic_button.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_bloc.dart';
import 'package:tunezmusic/presentation/premium/bloc/payment_event.dart';

class BuildPremiumMiniFeatures extends StatelessWidget {
  final Map<String, dynamic> plan;
  const BuildPremiumMiniFeatures({super.key, required this.plan});
  String formatPrice(int price) {
  return NumberFormat("#,###", "vi_VN").format(price);
}
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
              plan["name"],
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
                        decoration: TextDecoration.underline,
                      ),
                      children: [
                        TextSpan(text: "${formatPrice(plan["price"])}đ",),
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
                      children: List.generate(
                        plan["features"].length,
                        (index) =>
                            TextSpan(text: "• ${plan["features"][index]}\n"),
                      ),
                    ),
                  ),
            SizedBox(
              height: 15,
            ),
            BasicAppButton(
              onPressed: () {
                 context.read<PaymentBloc>().add(SelectPayment(
                        itemId: plan["id"],
                        amount: plan["price"],
                        paymentMethod:"MOMO"
                      ));
              },
              title: "Mua ${plan["name"]}",
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
                    child: RichText(
                      textAlign: TextAlign.center, // Căn giữa,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: '${plan["description"]}\n'),
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
  );
}
}