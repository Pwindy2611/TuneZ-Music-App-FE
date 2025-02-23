import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:tunezmusic/presentation/intro/pages/get_started.dart';

 class BackGreyAppButton extends StatelessWidget{
  final VoidCallback onPressed;
  final Color ? colors;
  final Color ? btnColor;
  final double ? textSize;
  final double ? size ;

  const BackGreyAppButton({
    required this.onPressed,
    required this.colors,
    required this.btnColor,
    required this.textSize,
    required this.size,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(context,
        MaterialPageRoute(
          builder: (BuildContext context) => GetStartedPage()
        ));
          });
      },
      icon: Container(
        height: size ?? 50,
        width: size ?? 50,
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          shape: BoxShape.circle
        ),
        child: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: colors ?? AppColors.grey,
        size: textSize ?? 18,
      ),
      ) 
    );
  }
 }