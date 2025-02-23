import 'package:flutter/material.dart';
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
    const HomeAppBar({super.key});
    
    @override
    Widget build(BuildContext context) {
        return AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Row(
            
          )
        );
    }
    
      @override
      // TODO: implement preferredSize
      Size get preferredSize => Size.fromHeight(70);
}