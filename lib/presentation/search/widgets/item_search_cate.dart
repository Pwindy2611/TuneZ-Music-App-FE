// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';

class ItemCateSearch extends StatefulWidget {
  final String image;
  final String name;
  final Color backgroundColor;
  final double border_radius;

  const ItemCateSearch({
    super.key,
    required this.name,
    required this.image,
    required this.border_radius,
    required this.backgroundColor,
  });

  @override
  _ItemCateSearchState createState() => _ItemCateSearchState();
}

class _ItemCateSearchState extends State<ItemCateSearch> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isTapped = true),
      onTapUp: (_) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      child: AnimatedScale(
        scale: isTapped ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.border_radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Text ở góc trên trái
              Positioned(
                width: 90,
                top: 10,
                left: 10,
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Image ở góc dưới phải, nghiêng 45 độ
              Positioned(
                bottom: 5,
                right: 5,
                child: Transform.translate(
                  offset: const Offset(20, 0), // Dịch sang phải 20px
                  child: Transform.rotate(
                    angle: 25 * 3.1415926535 / 180, // Xoay 25 độ
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.border_radius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // Màu bóng đổ
                            blurRadius: 5, // Độ mờ
                            spreadRadius: 2, // Độ lan
                            offset: const Offset(5, 5), // Dịch bóng xuống phải
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.border_radius),
                        child: Image.network(
                          widget.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Hiệu ứng khi nhấn vào
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isTapped ? 0.3 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(widget.border_radius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
