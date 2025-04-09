import 'package:flutter/material.dart';
import 'package:tunezmusic/common/widgets/button/light_button.dart';

class ButtonBottomDialog extends StatelessWidget {
  final VoidCallback onPressed;
  const ButtonBottomDialog({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: LightAppButton(
        onPressed: onPressed,
        title: "Xong",
        height: 80,
        colors: Colors.black,
        btnColor: Colors.white,
        textSize: 18,
      )
    );
  }
}
