import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video))
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0.0);
      });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.5) {
      // Nếu video hiển thị ít nhất 50% trên màn hình thì phát
      _controller.play();
    } else {
      // Nếu không, tạm dừng video
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.video), // Đảm bảo mỗi video có một key duy nhất
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTapDown: (_) => setState(() => isTapped = true),
        onTapUp: (_) => setState(() => isTapped = false),
        onTapCancel: () => setState(() => isTapped = false),
        onLongPress: () => setState(() {
          _controller.play();
          _controller.setLooping(true);
        }),
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
                Positioned.fill(
                    child: _controller.value.isInitialized
                        ? VideoPlayer(_controller)
                        : Container(color: Colors.black)), // Hiển thị nền đen nếu chưa load xong video
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
      ),
    );
  }
}
