import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Hàm tạo `BottomNavigationBarItem`
BottomNavigationBarItem buildBottomNavItem({
  required int index,
  required String icon,
  required String focusedIcon,
  required String label,
  required int selectedIndex,
  required int? tappedIndex,
  required void Function(int) onItemTapped,
}) {
  return BottomNavigationBarItem(
    icon: GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedScale(
        scale: tappedIndex == index ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.5),
              child: SvgPicture.asset(
                selectedIndex == index ? focusedIcon : icon,
                height: 26,
              ),
            ),
          ],
        ),
      ),
    ),
    label: label,
  );
}
