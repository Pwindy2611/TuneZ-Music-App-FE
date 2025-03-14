import 'package:flutter/material.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class ArtistAndPodcastersColumn extends StatefulWidget {
  final String image;
  final String name;
  final int borderRadius;

  const ArtistAndPodcastersColumn({
    super.key,
    required this.name,
    required this.image,
    required this.borderRadius,
  });

  @override
  _ArtistAndPodcastersColumnState createState() => _ArtistAndPodcastersColumnState();
}

class _ArtistAndPodcastersColumnState extends State<ArtistAndPodcastersColumn> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isTapped = true),
      onTapUp: (_) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            scale: isTapped ? 0.95 : 1.0, // Khi nhấn vào, ảnh sẽ to ra 1.1 lần
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius.toDouble()),
                    child: Image.network(widget.image, height: 140, width: 140),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 140,
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        // Text(widget.artist,
                        //     style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.normal,
                        //         color: AppColors.deFautLabelIcon),
                        //     textAlign: TextAlign.left,
                        //     softWrap: false,
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay khi nhấn vào
           Positioned.fill(
            child: AnimatedOpacity(
              opacity: isTapped ? 0.3 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Màu overlay
                  borderRadius: BorderRadius.circular(widget.borderRadius.toDouble()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
