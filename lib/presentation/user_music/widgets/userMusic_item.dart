import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';

class UserMusicItemWidget extends StatefulWidget {
  final Map tracks;
  final Color? prColor;
  const UserMusicItemWidget({super.key, required this.tracks, this.prColor});

  @override
  _UserMusicItemWidgetState createState() => _UserMusicItemWidgetState();
}

class _UserMusicItemWidgetState extends State<UserMusicItemWidget> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        bool _isPlaying = false;

        if (state is MusicLoaded) {
          _isPlaying = state.currentMusicId == widget.tracks['_id'];
        }

        return GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTap: () {
            context
                .read<MusicBloc>()
                .add(PlayStreamMusic(musicId: widget.tracks['_id']));
          },
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          widget.tracks['imgPath'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tracks['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isPlaying ? widget.prColor : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                               Text(
                            widget.tracks['artist'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '•',
                            style: TextStyle(color: Colors.grey),
                          ),
                           SizedBox(width: 4),
                          Text(
                            widget.tracks['genres'][0]['name'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                            ]
                          )
                         
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert_outlined, size: 28, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
