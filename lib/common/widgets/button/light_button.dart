import 'package:flutter/material.dart';

class LightAppButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? colors;
  final String? icon;
  final Color? btnColor;
  final double? textSize;

  const LightAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.colors,
    this.icon,
    this.btnColor,
    this.textSize,
    super.key,
  });

  @override
  State<LightAppButton> createState() => _LightAppButtonState();
}

class _LightAppButtonState extends State<LightAppButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: IntrinsicWidth( // Chiều ngang button sẽ vừa với nội dung
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.btnColor ?? Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: Size.zero, // Không đặt kích thước tối thiểu
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ôm sát nội dung
              children: [
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      widget.icon!,
                      width: 26,
                      height: 26,
                    ),
                  ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.colors ?? Colors.black,
                    fontSize: widget.textSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
