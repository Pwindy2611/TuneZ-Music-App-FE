import 'package:flutter/material.dart';

class BasicAppButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? colors;
  final String? icon;
  final Color? btnColor;
  final double? textSize;
  final double? padding;

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.colors,
    this.icon,
    this.btnColor,
    this.textSize,
    this.padding,
    super.key,
  });

  @override
  State<BasicAppButton> createState() => _BasicAppButtonState();
}

class _BasicAppButtonState extends State<BasicAppButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0; // Giá trị scale ban đầu

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
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.btnColor ?? Colors.white,
            minimumSize: Size.fromHeight(widget.height ?? 70),
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
            child:
            Padding(padding:EdgeInsets.symmetric(vertical: widget.padding ?? 16 ),child:Text(
                widget.title,
                style: TextStyle(
                  color: widget.colors ?? Colors.black,
                  fontSize: widget.textSize ?? 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),) 
          )
            ],
          ),
        ),
      ),
    );
  }
}
