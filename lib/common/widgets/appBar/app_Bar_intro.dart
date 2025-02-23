import 'package:tunezmusic/common/widgets/button/backGrey_button.dart';
import 'package:flutter/material.dart';
class IntroAppBar extends StatelessWidget implements PreferredSizeWidget {
    const IntroAppBar({super.key});
    
    @override
    Widget build(BuildContext context) {
        return AppBar(
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