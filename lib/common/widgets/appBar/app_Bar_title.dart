import 'package:tunezmusic/common/widgets/button/backGrey_button.dart';
import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? titleSize;
  final Color? titleColor;
  final Color? bgColor;
  final VoidCallback? onBackPressed; // Thêm hàm onPressed

  const TitleAppBar({
    required this.title,
    this.titleSize,
    this.titleColor,
    this.bgColor,
    this.onBackPressed, // Nhận giá trị callback
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: titleSize ?? 20,
          fontWeight: FontWeight.bold,
          color: titleColor ?? Colors.white,
        ),
      ),
      titleSpacing: 0,
      centerTitle: true,
      backgroundColor: bgColor ?? Colors.transparent,
      elevation: 0,
      leading: BackGreyAppButton(
        onPressed: onBackPressed ?? () =>(){
          Navigator.pop(context);
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(milliseconds: 300));} , // Mặc định quay lại trang trước
        size: 50,
        colors: null,
        btnColor: null,
        textSize: 18,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
