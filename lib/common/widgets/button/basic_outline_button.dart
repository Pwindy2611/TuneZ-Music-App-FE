import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class BasicAppOlButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? colors;
  final String? icon;
  final Color? outlineColor;
  final double? textSize;

  const BasicAppOlButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.colors,
    this.icon,
    this.outlineColor,
    this.textSize,
    super.key,
  });

  @override
  _BasicAppOlButtonState createState() => _BasicAppOlButtonState();
}

class _BasicAppOlButtonState extends State<BasicAppOlButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Giảm kích thước khi nhấn
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Trở lại kích thước bình thường
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Trở lại kích thước nếu hủy nhấn
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed, // Gọi callback khi nhấn
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: null, // Chuyển sự kiện onPressed qua GestureDetector
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.darkGrey; 
              }
              return Colors.transparent; 
            }),
            foregroundColor: WidgetStateProperty.all(widget.colors ?? Colors.black),
            side: WidgetStateProperty.all(
              BorderSide(
                color: widget.outlineColor ?? AppColors.darkGrey,
                width: 2,
              ),
            ),
            minimumSize: WidgetStateProperty.all(
              Size.fromHeight(widget.height ?? 70),
            ),
          ),
          child: Stack(
             alignment: Alignment.center,
            children: [
              if(widget.icon!=null) 
             Align(
            alignment: Alignment.centerLeft,
            child:Padding(
                padding: const EdgeInsets.only(left: 0), 
                child: Image.asset(
                  widget.icon ?? '',
                  width: 26,
                  height: 26,
                ),
              ),
          ),
          Center(
            child: Text(
                widget.title,
                style: TextStyle(
                  color: widget.colors ?? Colors.black,
                  fontSize: widget.textSize ?? 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
          )
            ],
          ),
        ),
      ),
    );
  }
}
