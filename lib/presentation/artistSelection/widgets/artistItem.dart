import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class ArtistItemSelector extends StatefulWidget {
  final String image;
  final String name;
  final String id;
  final bool isSelected;
  final VoidCallback onSelect;

  const ArtistItemSelector({
    super.key,
    required this.name,
    required this.image,
    required this.id,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  _ArtistItemSelectorState createState() => _ArtistItemSelectorState();
}

class _ArtistItemSelectorState extends State<ArtistItemSelector> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isTapped = true),
      onTapUp: (_) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      onTap: widget.onSelect, // Gọi hàm chọn/bỏ chọn
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            scale: isTapped ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                    border: widget.isSelected
                        ? Border.all(color: AppColors.primary, width: 3)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 120,
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: isTapped ? 0.3 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
