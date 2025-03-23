import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserMusicState extends MusicEvent {}

class PlayStreamMusic extends MusicEvent {
  final String musicId;
  PlayStreamMusic({required this.musicId});
  @override
  List<Object?> get props => [musicId];
}

class PlayMusic extends MusicEvent {
  final String musicId;
  PlayMusic({required this.musicId});
  @override
  List<Object?> get props => [musicId];
}

class PauseMusic extends MusicEvent {
  final String musicId;
  PauseMusic({required this.musicId});
  @override
  List<Object?> get props => [musicId];
}

class UpdatePlaylist extends MusicEvent {}

class SeekMusic extends MusicEvent {
  final Duration position;
  SeekMusic(this.position);
  @override
  List<Object?> get props => [position];
}

class UpdatePosition extends MusicEvent {
  final Duration position;
  UpdatePosition({required this.position});
  @override
  List<Object?> get props => [position];
}