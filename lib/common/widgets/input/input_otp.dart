import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class OtpTextField extends StatelessWidget {
  final int index;
  final List<TextEditingController> controllers;

  const OtpTextField({super.key, required this.index, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
    height: 80,
    width: 50,
    child: AspectRatio(
      aspectRatio: 1.0,
      child: TextField(
        controller: controllers[index],
        autofocus: false,
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus(); 
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus(); 
          }
        },
        showCursor: true,
        cursorColor: Colors.white,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: Offstage(),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.focusInput),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}
}
