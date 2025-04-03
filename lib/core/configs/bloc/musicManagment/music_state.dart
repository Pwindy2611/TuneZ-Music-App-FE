import 'package:equatable/equatable.dart';

abstract class MusicState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicNewAccount extends MusicState {}
class MusicLoaded extends MusicState {
  final String currentMusicId;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final String? musicUrl;
  final String? name;
  final String? artist;
  final String? lyrics;

  MusicLoaded(
     {  
    required this.name, 
    required this.artist,
    required this.currentMusicId,
    required this.isPlaying,
    required this.duration,
    required this.position,
    this.musicUrl,
    this.lyrics, 
  });

  MusicLoaded copyWith({
    String? currentMusicId,
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    String? musicUrl,
    String? name,
    String? artist,
    String? lyrics,
  }) {
    return MusicLoaded(
      name: name?? this.name,
      artist: artist?? this.artist,
      currentMusicId: currentMusicId ?? this.currentMusicId,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      musicUrl: musicUrl ?? this.musicUrl,
      lyrics: lyrics ?? this.lyrics,
    );
  }

  @override
  List<Object?> get props => [currentMusicId, isPlaying, duration, position, musicUrl,];
}
