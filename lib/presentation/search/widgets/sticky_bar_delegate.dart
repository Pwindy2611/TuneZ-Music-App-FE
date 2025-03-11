import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 100; // Chiều cao tối thiểu
  @override
  double get maxExtent => 100; // Chiều cao tối đa

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child:
      Column(
        children: [
          SizedBox(height: 40,) ,
          TextField(
        style: const TextStyle(color: Colors.black),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: "Bạn muốn nghe gì...",
          hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
        ]
      )
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
