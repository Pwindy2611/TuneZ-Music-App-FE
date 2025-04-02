import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_bloc.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_event.dart';
import 'package:tunezmusic/presentation/music/bloc/music_love_state.dart';
import 'package:tunezmusic/presentation/music/widgets/audio_progress_bar.dart';
import 'package:tunezmusic/presentation/music/widgets/popupMusicPlayDetails.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late StreamSubscription _lifecycleSubscription;
  Color _dominantColor = AppColors.darkGrey;
  String? _currentMusicUrl = "https://th.bing.com/th/id/OIP.bLCU8HwL546JIVk9vLV3NAHaHa?rs=1&pid=ImgDetMain";

  @override
  void initState() {
    super.initState();
    _currentMusicUrl;
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.detached.toString()) {
        _pauseMusicBeforeExit();
      }
      return null;
    });
  }

  void _pauseMusicBeforeExit() {
    final musicBloc = context.read<MusicBloc>();
    if (musicBloc.state is MusicLoaded &&
        (musicBloc.state as MusicLoaded).isPlaying) {
      musicBloc.add(
          PauseMusic(musicId: (musicBloc.state as MusicLoaded).currentMusicId));
    }
  }

  Future<void> _extractDominantColor(String musicUrl) async {
    if (musicUrl.isEmpty) return;

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(musicUrl));

    final Color newColor = paletteGenerator.dominantColor?.color ?? AppColors.grey;

    // Calculate brightness (0.0 = dark, 1.0 = light)
    final double brightness = (newColor.red * 0.299 + newColor.green * 0.587 + newColor.blue * 0.114) / 255;

    // Adjust factor based on brightness
    final double factor = brightness > 0.5 ? 0.4 : 1.9; // Darken light colors, subtly lighten dark colors
    final Color adjustedColor = Color.fromARGB(
      newColor.alpha,
      (newColor.red * factor).clamp(0, 255).toInt(),
      (newColor.green * factor).clamp(0, 255).toInt(),
      (newColor.blue * factor).clamp(0, 255).toInt(),
    );

    if (adjustedColor != _dominantColor) {
      setState(() {
        _dominantColor = adjustedColor;
      });
    }
  }

  void _showMusicControlBottomSheet(BuildContext context, MusicLoaded state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Ensure the BottomSheet can expand fully
    backgroundColor: Colors.transparent,
    builder: (context) {
      return PopupMusicPlayDetails(state: state, dominantColor: _dominantColor,imgURL:_currentMusicUrl ,);
    },
  );
}

  @override
  void dispose() {
    _lifecycleSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          if (_currentMusicUrl != state.musicUrl) {
            _currentMusicUrl = state.musicUrl;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _extractDominantColor(_currentMusicUrl!);
            });
          }
          return Positioned(
            bottom: 70,
            left: 10,
            child: GestureDetector(
              onTap: () => _showMusicControlBottomSheet(context, state),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _dominantColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              key: ValueKey(state.musicUrl),
                              state.musicUrl ?? "https://th.bing.com/th/id/OIP.bLCU8HwL546JIVk9vLV3NAHaHa?rs=1&pid=ImgDetMain",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width -
                                    46 -
                                    180,
                                height: 20,
                                child: Marquee(
                                  text: state.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 70,
                                  velocity: 20.0,
                                  startPadding: 5.0,
                                ),
                              ),
                              Text(
                                state.artist ?? "",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BlocBuilder<MusicLoveBloc,MusicLoveState>(
                                builder: (context,loveState){
                                  if(loveState is MusicLoveSuccess)
                                  {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.check_circle_rounded,
                                        size: 30,
                                        color: const Color.fromARGB(255, 79, 170, 82),
                                      ),
                                      onPressed: () {
                                      },
                                    );
                                  }
                                  return  IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    context.read<MusicLoveBloc>().add(SaveLoveMusicEvent(state.currentMusicId));
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline_sharp,
                                    size: 28,
                                    color: Colors.white,
                                  )
                                );
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  state.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 34,
                                ),
                                onPressed: () {
                                  context.read<MusicBloc>().add(
                                        state.isPlaying
                                            ? PauseMusic(
                                                musicId: state.currentMusicId)
                                            : PlayMusic(
                                                musicId: state.currentMusicId),
                                      );
                                },
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: AudioProgressBar(),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is MusicNewAccount) {
          return SizedBox.shrink();
        }
        return SizedBox.shrink();
      },
    );
  }
}
