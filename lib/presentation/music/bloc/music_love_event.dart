import 'package:equatable/equatable.dart';

abstract class MusicLoveEvent extends Equatable {
  const MusicLoveEvent();

  @override
  List<Object?> get props => [];
}

class SaveLoveMusicEvent extends MusicLoveEvent {
  final String musicId;

  const SaveLoveMusicEvent(this.musicId);

  @override
  List<Object?> get props => [musicId];
}