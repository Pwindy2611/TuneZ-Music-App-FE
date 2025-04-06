import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_bloc.dart';
import 'package:tunezmusic/core/configs/bloc/musicManagment/music_state.dart';

class AudioProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          final position = state.position.inSeconds.toDouble();
          final duration = state.duration.inSeconds.toDouble();
          if (duration == 0) {
            return Container();
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: double.maxFinite,
            height: 2, // Chiều cao của thanh tiến trình
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Đặt borderRadius
              child: LinearProgressIndicator(
                value: position / duration,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}