import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserMusicState extends MusicEvent {}

class PlayMusic extends MusicEvent {
  final String musicId;
  PlayMusic( {required this.musicId});
  @override
  List<Object?> get props => [musicId];
}

class PauseMusic extends MusicEvent {}

class SeekMusic extends MusicEvent {
  final Duration position;
  SeekMusic(this.position);
  @override
  List<Object?> get props => [position];
}