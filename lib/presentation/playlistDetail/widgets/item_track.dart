import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';

class TrackItemWidget extends StatefulWidget {
  final Map track;
  final Color? prColor;
  const TrackItemWidget(
      {super.key, required this.track, this.prColor});

  @override
  _TrackItemWidgetState createState() => _TrackItemWidgetState();
}

class _TrackItemWidgetState extends State<TrackItemWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        bool _isPlaying = false;

        if (state is MusicLoaded) {
          if (state.currentMusicId == widget.track['_id']) {
            _isPlaying = true;
          } else {
            _isPlaying = false;
          }
        }

        return GestureDetector(
          onTap: () {
            print("Nhấn vào bài: ${widget.track['name']}");
            context
                .read<MusicBloc>()
                .add(PlayStreamMusic(musicId: widget.track['_id']));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        widget.track['imgPath'],
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.track['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isPlaying ? widget.prColor : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.track['artist'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.more_vert_outlined,
                    size: 28, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
