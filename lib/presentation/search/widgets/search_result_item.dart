import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/bloc/navigation_bloc.dart';

class SearchResultItem extends StatefulWidget {
  final Map item;
  final List<dynamic>? allTracks;
  final Color? prColor;

  const SearchResultItem({
    super.key,
    required this.item,
    this.allTracks,
    this.prColor,
  });

  @override
  State<SearchResultItem> createState() => _SearchResultItemState();
}

class _SearchResultItemState extends State<SearchResultItem> {
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
    if (widget.item['type'] == 'Song') {
      return BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          bool _isPlaying = false;
          if (state is MusicLoaded) {
            _isPlaying = state.currentMusicId == widget.item['_id'];
          }

          return GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTap: () {
              if (widget.allTracks != null) {
                context.read<MusicBloc>().add(UpdatePlaylist(
                  allTracks: widget.allTracks!
                ));
              }
              context.read<MusicBloc>().add(PlayStreamMusic(musicId: widget.item['_id']));
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
                            widget.item['imgPath'],
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
                              widget.item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isPlaying ? widget.prColor : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.item['artist'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Artist type
      return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTap: () {
          context.read<NavigationBloc>().add(
            OpenArtistDetailEvent(
              widget.item['imgPath'],
              widget.item['name']
            )
          );
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.item['imgPath'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.item['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
} 