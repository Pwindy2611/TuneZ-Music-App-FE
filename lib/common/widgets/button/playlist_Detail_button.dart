import 'package:flutter/material.dart';

class PlaylistAppButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? colors;
  final String? icon;
  final double? textSize;

  const PlaylistAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.colors,
    this.icon,
    this.textSize,
    super.key,
  });

  @override
  State<PlaylistAppButton> createState() => _PlaylistAppButtonState();
}

class _PlaylistAppButtonState extends State<PlaylistAppButton> {
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(67, 255, 255, 255),
            borderRadius: BorderRadius.circular(4),
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
    );
  }
}
