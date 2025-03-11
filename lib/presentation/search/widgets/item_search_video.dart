import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ItemVideoSearch extends StatefulWidget {
  final String name;
  final String video;
  final double border_radius;

  const ItemVideoSearch({
    super.key,
    required this.name,
    required this.border_radius,
    required this.video,
  });

  @override
  _ItemVideoSearchState createState() => _ItemVideoSearchState();
}

class _ItemVideoSearchState extends State<ItemVideoSearch> {
  late VideoPlayerController _controller;
  bool isVisible = false;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video))
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() =>
          {isTapped = true}),
      onTapUp: (_) => setState(() => isTapped = false),
      onTapCancel: () => setState(() => isTapped = false),
      onLongPress:() => setState(() {_controller.play(); _controller.setLooping(true);}),
      child: AnimatedScale(
        scale: isTapped ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.border_radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(child: VideoPlayer(_controller)),
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
              Positioned(
                width: 90,
                bottom: 10,
                left: 10,
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
