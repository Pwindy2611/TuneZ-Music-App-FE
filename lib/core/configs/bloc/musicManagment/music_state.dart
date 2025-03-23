import 'package:equatable/equatable.dart';

abstract class MusicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicNewAccount extends MusicState {}
class MusicLoaded extends MusicState {
  final String currentMusicId;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final String? musicUrl;

  MusicLoaded({
    required this.currentMusicId,
    required this.isPlaying,
    required this.duration,
    required this.position,
    this.musicUrl,
  });

  MusicLoaded copyWith({
    String? currentMusicId,
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    String? musicUrl,
  }) {
    return MusicLoaded(
      currentMusicId: currentMusicId ?? this.currentMusicId,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      musicUrl: musicUrl ?? this.musicUrl,
    );
  }

  @override
  List<Object?> get props => [currentMusicId, isPlaying, duration, position, musicUrl];
}