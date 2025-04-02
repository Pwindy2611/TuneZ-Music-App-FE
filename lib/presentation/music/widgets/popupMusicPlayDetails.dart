import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tunezmusic/core/configs/assets/app_vectors.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_event.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';
import 'package:tunezmusic/core/configs/theme/app_colors.dart';

class PopupMusicPlayDetails extends StatefulWidget {
  final MusicLoaded state;
  final Color _dominantColor;
  final String? imgURL;

  const PopupMusicPlayDetails({
    super.key,
    required this.state,
    required Color dominantColor,
    required this.imgURL,
  }) : _dominantColor = dominantColor;

  @override
  State<PopupMusicPlayDetails> createState() => _PopupMusicPlayDetailsState();
}

class _PopupMusicPlayDetailsState extends State<PopupMusicPlayDetails> {
  late double _sliderValue;
  late MusicLoaded _currentState; // Make state reactive

  @override
  void initState() {
    super.initState();
    _currentState = widget.state; // Initialize with the passed state
    _sliderValue = _currentState.position.inSeconds.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicLoaded) {
          setState(() {
            _currentState = state; // Update the reactive state
            _sliderValue = state.position.inSeconds.toDouble();
          });
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 1.0, // Start fully expanded
        minChildSize: 0.5, // Allow collapsing to half the screen
        maxChildSize: 1.0, // Allow full-screen expansion
        expand: true,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget._dominantColor,
                  AppColors.darkBackground,
                ],
              ),
            ),
            child: Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              "ĐANG PHÁT TỪ NGHỆ SĨ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            ),
                            Text(
                              _currentState.artist ?? "", // Use the reactive state
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert_outlined,
                              size: 28,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _currentState.musicUrl ?? '', // Use the reactive state
                        width: 320,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentState.name ?? "", // Use the reactive state
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              _currentState.artist ?? "", // Use the reactive state
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_circle_outline_sharp,
                              size: 32,
                              color: Colors.white,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2, // Reduce the height of the slider
                        thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 5), // Shrink the seek button
                        overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 0), // Adjust overlay size
                      ),
                      child: Slider(
                        value: _sliderValue,
                        max: _currentState.duration.inSeconds.toDouble(), // Use the reactive state
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                          context.read<MusicBloc>().add(
                                SeekMusic(
                                  Duration(seconds: value.toInt()),
                                ),
                              );
                        },
                        activeColor: Colors.white,
                        inactiveColor: const Color.fromARGB(75, 255, 255, 255),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(_sliderValue.toInt() ~/ 60).toString().padLeft(2, '0')}:${(_sliderValue.toInt() % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          "${(_currentState.duration.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentState.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            AppVectors.shuffleIcon,
                            color: Colors.white,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0), // Shift the row to the right
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensure the row takes minimal width
                              children: [
                                IconButton(
                                  onPressed: () {
                                       context
                                          .read<MusicBloc>()
                                          .add(RanDomTrackEvent());
                                  },
                                  icon: Icon(
                                    Icons.skip_previous_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                BlocBuilder<MusicBloc, MusicState>(
                                    builder: (context, state) {
                                  if (state is MusicLoaded) {
                                    return IconButton(
                                      onPressed: () {
                                        context.read<MusicBloc>().add(
                                              state.isPlaying
                                                  ? PauseMusic(
                                                      musicId:
                                                          state.currentMusicId)
                                                  : PlayMusic(
                                                      musicId:
                                                          state.currentMusicId),
                                            );
                                      },
                                      icon: Icon(
                                        state.isPlaying
                                            ? Icons.pause_circle_filled_rounded
                                            : Icons.play_circle_fill_rounded,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read<MusicBloc>()
                                          .add(RanDomTrackEvent());
                                    },
                                    icon: Icon(
                                      Icons.skip_next_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.speed_rounded,
                              color: Colors.white,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
