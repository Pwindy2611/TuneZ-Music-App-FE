import 'dart:ui';
import 'package:flutter/material.dart';

class PlayListAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double blurAmount;
  final String title;
  final VoidCallback? onBackPressed;

  const PlayListAppBar({
    Key? key,
    required this.blurAmount,
    required this.onBackPressed, 
    required this.title,
  }) : super(key: key);

  @override
  State<PlayListAppBar> createState() => _PlayListAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _PlayListAppBarState extends State<PlayListAppBar> {
  @override
  Widget build(BuildContext context) {
    double opacity = widget.blurAmount/20 ; 
    double blurAmount = widget.blurAmount / 100;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          // Hiệu ứng mờ nền AppBar
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurAmount,
                  sigmaY: widget.blurAmount,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(
                            lerpDouble(0, 0.6, blurAmount) ?? 0), // Màu trên
                        Colors.white.withOpacity(
                            lerpDouble(0, 0.5, blurAmount) ?? 0), // Màu dưới
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Nội dung AppBar
          Container(
            height: 90,
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: widget.onBackPressed,
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),

                // Thêm AnimatedOpacity để chữ "Thắng" hiện dần khi scroll lên
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: opacity.clamp(0.0, 1.0), // Đảm bảo giá trị từ 0 đến 1
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
