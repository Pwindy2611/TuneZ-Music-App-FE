import 'package:flutter/material.dart';
import 'dart:async';

class DotsLoading extends StatefulWidget {
  @override
  _DotsLoadingState createState() => _DotsLoadingState();
}

class _DotsLoadingState extends State<DotsLoading> {
  int _currentDot = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 400), (timer) {
      if (mounted) {
        setState(() {
          _currentDot = (_currentDot + 1) % 3;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: _currentDot == index ? 20 :15,
          height: _currentDot == index ? 20 :15,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        );
      }),
    ),);
  }
}
