import 'package:equatable/equatable.dart';

abstract class MusicLoveListEvent extends Equatable {
  const MusicLoveListEvent();

  @override
  List<Object?> get props => [];
}

class FetchMusicLoveListEvent extends MusicLoveListEvent {}