import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class EnabledButton extends StatelessWidget {
  final bool isEnabled;
  final  isLoading;
  final VoidCallback onPressed;
  final String title;

  const EnabledButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Colors.white : AppColors.focusInput,
        foregroundColor: isEnabled ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
    );
  }
}
