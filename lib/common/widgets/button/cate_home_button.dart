import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class CateHomeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const CateHomeButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : const Color.fromARGB(55, 255, 255, 255), // Đổi màu khi được chọn
        minimumSize: const Size(50, 30),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white, // Đổi màu chữ khi được chọn
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
