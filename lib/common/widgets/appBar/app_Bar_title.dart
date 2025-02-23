import 'package:tunezmusic/common/widgets/button/backGrey_button.dart';
import 'package:flutter/material.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
    final String title;
    final double? titleSize;
    final Color? titleColor;
    const TitleAppBar({
      required this.title,
      required this.titleSize,
      required this.titleColor,
      super.key});
    
    @override
    Widget build(BuildContext context) {
        return AppBar(
          title: Text(
            title ,
            style: TextStyle(
              fontSize: titleSize ?? 20, 
              fontWeight: FontWeight.bold,
              color: titleColor ?? Colors.white
              ),
          ),
          titleSpacing: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:  BackGreyAppButton(
          onPressed: (){},
          size: 50,
          colors: null, 
          btnColor: null,
          textSize: 18,
        ),
        );
    }
    
      @override
      // TODO: implement preferredSize
      Size get preferredSize => Size.fromHeight(70);
}